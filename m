Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbbA2MQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:16:47 -0500
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:3248
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752668AbbA2MQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:16:44 -0500
X-AuditID: ac160a69-f79956d000002b3c-c2-54ca24a77e42
Message-ID: <54CA24A5.1060806@sandisk.com>
Date: Thu, 29 Jan 2015 13:16:37 +0100
From: Bart Van Assche <bart.vanassche@sandisk.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
References: <1421600146.2080.8.camel@HansenPartnership.com>
	 <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au>
	 <1421683701.2080.25.camel@HansenPartnership.com>
	 <871tmqcmau.fsf@rustcorp.com.au>
	 <1421774615.2080.88.camel@HansenPartnership.com>
	 <20150122165018.GA27377@infradead.org>
	 <1421946175.2093.1.camel@HansenPartnership.com>
	 <87iofyurzc.fsf@rustcorp.com.au> <20150123131758.GC8045@infradead.org>
	 <1422038567.2126.14.camel@HansenPartnership.com>
	 <54C8AAA9.7060300@sandisk.com>
 <1422481550.2086.16.camel@HansenPartnership.com>
In-Reply-To: <1422481550.2086.16.camel@HansenPartnership.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI8azSHe5yqkQg9UnbCxOT1jEZLGxn8Pi
	8q45bBbd13ewWazfu4bJ4ua0CywObB7TJp1i82g9s4bFY/MKLY8VG04we3zeJBfAGsVlk5Ka
	k1mWWqRvl8CVMWveXaaCM/wVs58rNzAe5Oli5OSQEDCRWP5yAwuELSZx4d56ti5GLg4hgROM
	EvO+tLGBJIQEdjBKXFksA9Pw7eJcZoiiLYwSDw4cBiviFdCSeHPjHNAkDg4WAVWJD4tDQMJs
	AkYS397PBFsgKhAm8X3zDmaIckGJkzOfgMVFBKwlvqxawAgyk1ngAaPE4avHGEESwgKREps/
	rWGFWLaMRaJ500dWkASngK3EuWcTmUCWMQtoSqzfpQ8SZhaQl9j+dg7YcRICF1klZq1bxwzx
	gbrEySXzmSYwisxCsnwWQvssJO0LGJlXMYrlZuYU56anFhga6RUn5qVkFmfrJefnbmIERw5X
	5g7GFZPMDzEKcDAq8fAmNJ4MEWJNLCuuzD3EKMHBrCTCW6h0KkSINyWxsiq1KD++qDQntfgQ
	ozQHi5I4r+D0LH8hgfTEktTs1NSC1CKYLBMHp1QDY3pmrYHmE+dFOkvv7z650beWr/B8cuT6
	09obRQ80cZZJunvFdNYvn7Sk9xrXm+h4j42Bx4Rd7wTHLproMaFrbmF0k1Kux129znfXtuz8
	oR+Wlp09r7to9m3pw+c/bd7mtXbxlmlCMif2bZCcXfN+pfe8Kz41qXF9TyUPPjkYejHt9fmE
	u9/83JVYijMSDbWYi4oTAfZ/r3eYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsXCtZEjRXe5yqkQgxf9+hanJyxistjYz2Fx
	edccNovu6zvYLNbvXcNkcXPaBRYHNo9pk06xebSeWcPisXmFlseKDSeYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKmDXvLlPBGf6K2c+VGxgP8nQxcnJICJhIfLs4lxnCFpO4cG89WxcjF4eQwCZG
	icNnfjOBJHgFtCTe3DjH0sXIwcEioCrxYXEISJhNwEji2/uZLCC2qECYxPfNO5ghygUlTs58
	AhYXEbCW+LJqASPITGaBJ4wSSx4+BysSFoiU2PxpDSvEsmUsEs2bPrKCJDgFbCXOPZsItphZ
	QF3iz7xLzBC2vMT2t3OYJzDyz0KyZBaSsllIyhYwMq9iFMvNzCnOTc8sMDTSK07MS8ksztZL
	zs/dxAgOYM6oHYzXJ5ofYmTi4JRqYOy9Y3VAPc/Q4krVstvfEs7F6N4JzbluvWja8Ztb+bY2
	6LeZXPKb7xxrNO9FGf/b1GPhwTNOf6lsfdCt5RLqesfR4yz3ba5P9u+qH1ScW7yClUfm8j33
	pkVdtj84fk38fsbqm6Bku53RvHvPA7rmf2ERujhh+oIHhSVHey7/WntrGXv8Lo1TucuUWIoz
	Eg21mIuKEwG1A8KXEAIAAA==
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 63.163.107.173)
 smtp.mailfrom=Bart.VanAssche@sandisk.com; hitachi.com; dkim=none (message not
 signed) header.d=none;hitachi.com; dmarc=permerror action=none
 header.from=sandisk.com;
X-Forefront-Antispam-Report: CIP:63.163.107.173;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(24454002)(377424004)(51704005)(479174004)(46102003)(65806001)(47776003)(2950100001)(77096005)(83506001)(15975445007)(92566002)(76176999)(50986999)(86362001)(23676002)(54356999)(87266999)(36756003)(64126003)(33656002)(50466002)(106466001)(110136001)(62966003)(87936001)(93886004)(77156002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO1PR02MB127;H:milsmgep12.sandisk.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CO1PR02MB127;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB127;
X-Forefront-PRVS: 0471B73328
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2015 12:16:40.2137
 (UTC)
X-MS-Exchange-CrossTenant-Id: fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d;Ip=[63.163.107.173]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/15 22:45, James Bottomley wrote:
> On Wed, 2015-01-28 at 10:23 +0100, Bart Van Assche wrote:
>> Is this the latest version of this patch that is available ? I have
>> tried to test the above patch. However, I couldn't test the impact of
>> this patch on the SRP initiator driver since my test system didn't boot
>> anymore with the above patch applied. That test system boots from an ATA
>> disk managed by the SCSI subsystem:
>> $ lsscsi | head -n1
>> [0:0:0:0]    disk    ATA      KINGSTON SH103S3 BBF0  /dev/sda
> 
> Not yet, since I knew it would need a bit of testing to identify all the
> potential in_exit acquisitions.  However, you could help me by
> diagnosing the current failure.

Hello James,

I have done the following:
- Read over your patch but didn't spot anything obvious.
- Added printk() statements in the modified functions in an attempt to
  determine where in the boot process the hang occurs. Apparently none
  of the functions touched by this patch got called before the hang
  occurred.
- Uploaded a screenshot of the boot messages
(https://drive.google.com/file/d/0B1YQOreL3_FxN1pPMnZrSDdLYTQ/view?usp=sharing).
The most remarkable message is "SATA link down". This message does not
appear when booting e.g. kernel version v3.16.
- Left the system alone for a few minutes after the boot process
  stopped making progress. The message "boot drive not found" appeared.

So this is probably an issue in another component than the SCSI
subsystem. What's not clear to me is why every time I tried to boot
without this patch that booting succeeded and every time I tried to boot
with this patch applied that booting did not succeed ... I have not yet
had the time to run a bisect.

Note: the tests I ran today were performed with kernel v3.19-rc6 with
patch https://lkml.org/lkml/2015/1/28/334 applied. However, that last
patch shouldn't have any impact on the boot process since
CONFIG_SCSI_MQ_DEFAULT was not set.

Bart.

