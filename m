Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbaBUQqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:46:19 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:33152
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932740AbaBUQqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:46:17 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371Ie0eah1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N1CUKR-08-27N-02
X-M-MSG: 
Message-ID: <530782CB.5070301@amd.com>
Date: Fri, 21 Feb 2014 10:46:03 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
References: <20140217182729.GE4559@pd.tnic> <5302625C.4050700@amd.com> <20140217194153.GG4559@pd.tnic> <53028EE8.20106@amd.com> <20140218003654.GK4559@pd.tnic> <20140218084636.GA24465@pd.tnic> <5303A607.7090309@amd.com> <20140220093207.GB8876@pd.tnic> <53062845.8010203@amd.com> <20140220161351.GA2014@pd.tnic> <20140221142317.GB11531@pd.tnic>
In-Reply-To: <20140221142317.GB11531@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/2014 8:23 AM, Borislav Petkov wrote:
> On Thu, Feb 20, 2014 at 05:13:51PM +0100, Borislav Petkov wrote:
>> On Thu, Feb 20, 2014 at 10:07:33AM -0600, Aravind Gopalakrishnan wrote:
>>> Tested the above a final time on local machine and it works fine..
>> Ok, I'll queue it up with your Tested-by. Thanks.
> So I dropped the family check altogether, modulo the warning that says
> that we're getting loaded on unsupported hardware. We want to allow
> loading, even if we don't have family ops.
>
> Ok?

Yes, makes sense.

> --
> From: Borislav Petkov <bp@suse.de>
> Subject: [PATCH] MCE, AMD: Fix decoding module loading on unsupported hw
>
> We want to still be able to issue some error information on systems for
> which there is no decoding support (think older distro kernels here,
> for example). Therefore, we allow module registration but skip the
> per-family bank-specific decoders and issue the general information
> only, i.e.:
>
> [   46.822828] [Hardware Error]: Error Status: Uncorrected, software containable error.
> [   46.822846] [Hardware Error]: CPU:0 (15:30:0) MC0_STATUS[-|UE|-|-|-|-|-]: 0xa000000000010f0f
> [   46.822858] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, mem-tx: GEN, part-proc: GEN (timed out)
>
> with the hope that it still contains helpful useful bits.
>
> Suggested-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> Tested-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>   drivers/edac/mce_amd.c | 65 +++++++++++++++++++++++++-------------------------
>   1 file changed, 33 insertions(+), 32 deletions(-)
>
>

Works for me:

[    0.321623] Huh? What family is it: 0x15?!
[    0.321629] MCE: In-kernel MCE decoding enabled.
...
[   79.294568] [Hardware Error]: Uncorrected, software containable error.
[   79.294587] [Hardware Error]: CPU:0 (15:30:0) 
MC0_STATUS[-|UE|-|-|-|-|-]: 0xa000000000010f0f
[   79.294602] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, 
mem-tx: GEN, part-proc: GEN (timed out)

Thanks,
-Aravind

