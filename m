Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaKGQf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:35:28 -0500
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:39328
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133AbaKGQf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:35:26 -0500
Message-ID: <545CF3D8.1020500@opensource.altera.com>
Date: Fri, 7 Nov 2014 10:31:20 -0600
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Thor Thayer <tthayer@opensource.altera.com>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv3 4/5] edac: altera: Add Altera L2 Cache and OCRAM EDAC
 Support
References: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com> <1414683131-20786-5-git-send-email-tthayer@opensource.altera.com> <20141104151214.GD9570@pd.tnic> <545959E8.2040005@opensource.altera.com> <20141106163134.GF4318@pd.tnic>
In-Reply-To: <20141106163134.GF4318@pd.tnic>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR09CA0001.namprd09.prod.outlook.com (25.160.127.11) To
 BN3PR0301MB1185.namprd03.prod.outlook.com (25.160.156.147)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1185;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(199003)(377454003)(479174003)(76104003)(189002)(24454002)(164054003)(83506001)(92566001)(101416001)(99396003)(31966008)(65956001)(47776003)(42186005)(65806001)(20776003)(80316001)(64126003)(50466002)(66066001)(102836001)(120916001)(33656002)(64706001)(86362001)(4396001)(87976001)(76176999)(54356999)(62966003)(122386002)(46102003)(50986999)(107046002)(92726001)(95666004)(40100003)(23676002)(106356001)(105586002)(87266999)(77096003)(97736003)(65816999)(93886004)(21056001)(59896002)(77156002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1185;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1202;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 11/06/2014 10:31 AM, Borislav Petkov wrote:
> Hi Thor,
> 
> On Tue, Nov 04, 2014 at 04:57:44PM -0600, Thor Thayer wrote:
>> We want to at least separate L2/OCRAM ECC from the SDRAM ECC because
>> 1) the SDRAM preparation can take almost 2 seconds on boot and some
>> customers need a faster boot time.
>> 2) the SDRAM has an ECC initialization dependency on the preloader which is
>> outside the kernel. It is desirable to be able to turn the SDRAM on & off
>> separately.
> 
> Well, now that I asked and you gave valid reasons for the split,
> you should keep them split the way they are. But please do add that
> explanation to the commit message so that it is clear to people why
> there is a split.
> 
>> You bring up a good point about the L2 and OCRAM being combined though.
>>
>> If we do want granular control, maybe I should use a submenu? Or isn't that
>> desirable either?
> 
> Well, what do you think would be easier/faster for a user configuring? A
> separate menu where you have to do a couple of key presses just to enter
> it or simply a subtree in Kconfig with all the options together. I think
> the "depends" gives you that already...
> 
> Ok, once you've worked in the suggested changes, you're good to go,
> at least for the EDAC bits. Let me know how you want to handle this,
> whether I should pick up the whole thing or I should ack the EDAC parts.
> This patchset should go together, in any case, and so I don't care
> whoever picks it up.
> 

If it's okay, can you please pick up this series, once everything is
cleaned up? I just checked to make sure that there aren't any merge
conflicts in the DTS files in this series against DTS patches that I
have queue up for 3.19, and there aren't.

Thanks,
Dinh

