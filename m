Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaAQRhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:37:08 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:52844 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbaAQRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:37:04 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z579ehzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h1155h)
X-WSS-ID: 0MZK3J6-07-HY5-02
X-M-MSG: 
Message-ID: <52D96A32.5020801@amd.com>
Date: Fri, 17 Jan 2014 11:36:50 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D59ACC.3090100@amd.com> <20140114203848.GP29865@pd.tnic> <52D81DB5.7000608@amd.com> <20140117002123.GA9165@khazad-dum.debian.net> <20140117101842.GB8715@pd.tnic> <52D958FC.9020700@zytor.com> <20140117170213.GG8715@pd.tnic>
In-Reply-To: <20140117170213.GG8715@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2014 11:02 AM, Borislav Petkov wrote:
> On Fri, Jan 17, 2014 at 08:23:24AM -0800, H. Peter Anvin wrote:
>> Actually I by and large disagree with that. There is a limit, of
>> course, but when it comes to flipping an MSR in init code, the bar is
>> pretty darn low. We have quirks for all kind of hardware, and this is
>> just another example.
> No, you don't. :-)
>
> You would much prefer to have the workaround done in the BIOS and only
> if there's a coverage hole, only then to do it in the kernel.
>
> I'm not saying we shouldn't do it in the kernel per se - I'm saying we
> should do it only when really necessary. And it doesn't hurt to talk
> about it first before inviting in all fixes for all errata for all
> families of all vendors. No, you don't want that, believe me. :-)

Right, so the chip goes into multiple platforms (server,desktop..) and 
this Erratum affects all platforms the chip fits in..
Also, the problem is that we can't be certain how many systems in the 
field carry BIOSes with the fix for this. Therefore,
it is better to insulate ourselves than trust BIOS to do the right thing..

>
>> The effort of a kernel update is much lower, especially since the
>> kernel is generally automatically updated.
> Does that even matter? I think what matters is whether we reboot or not,
> i.e. HA crap. If we have to reboot, we might just as well flash the BIOS
> - it takes almost as long.

True, but isn't the case that it's more *likely* for sys admins to 
resort to updating kernels than program new BIOS?
The alternative would be to update microcode, but there is no microcode 
patch file for this family yet on linux-firmware..

I've got a patch worked up for this anyway; Sending it as separate mail..

Thanks,
Aravind.

