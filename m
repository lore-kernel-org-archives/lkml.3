Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaBQT0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:26:35 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:36901
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbaBQT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:26:33 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N15NC2-08-2L7-02
X-M-MSG: 
Message-ID: <5302625C.4050700@amd.com>
Date: Mon, 17 Feb 2014 13:26:20 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140217182729.GE4559@pd.tnic>
In-Reply-To: <20140217182729.GE4559@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/2014 12:27 PM, Borislav Petkov wrote:
> On Mon, Feb 17, 2014 at 11:49:51AM -0600, Aravind Gopalakrishnan wrote:
>> If MCE decoding support does not exist for a particular family/model,
>> and if one tries to inject errors using mce_amd_inj module, it leads
>> to kernel OOPS. Especially if we inject errors to MC0, MC1, MC2 banks.
> Well, we shouldn't even be loading the module on unsupported hw, i.e.,
> something like that:
>
>   
>   	if (c->x86_vendor != X86_VENDOR_AMD)
> -		return 0;
> +		return -ENODEV;
>   
>   	if (c->x86 < 0xf || c->x86 > 0x16)
> -		return 0;
> +		return -ENODEV;
>   
Ah. you are right. (I had tested against different family/model checks 
that happen to throw NULL dereference)
You can ignore the patch.

Apologies for the trouble.

-Aravind.

