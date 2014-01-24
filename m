Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaAXURV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:17:21 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:27709
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaAXURU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:17:20 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh8275dh1de097hz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZX9OO-07-FAU-02
X-M-MSG: 
Message-ID: <52E2CA48.4070500@amd.com>
Date: Fri, 24 Jan 2014 14:17:12 -0600
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Subject: Re: Fix ccp_run_passthru_cmd dma variable assignments
References: <20140124183934.GA3423@redhat.com>
In-Reply-To: <20140124183934.GA3423@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 12:39 PM, Dave Jones wrote:
> There are some suspicious looking lines of code in the new ccp driver, including
> one that assigns a variable to itself, and another that overwrites a previous assignment.
> 
> This may have been a cut-and-paste error where 'src' was forgotten to be changed to 'dst'.
> I have no hardware to test this, so this is untested.

Yes, this was a cut-and-paste error that was not discovered with my tests. I've
updated my testcases and tested/verified this fix.

Herbert, this should probably go through the cryptodev-2.6 tree right?

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,
Tom

> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 71ed3ade7e12..c266a7b154bb 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1666,8 +1666,8 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
>   
>   		op.dst.type = CCP_MEMTYPE_SYSTEM;
>   		op.dst.u.dma.address = sg_dma_address(dst.sg_wa.sg);
> -		op.src.u.dma.offset = dst.sg_wa.sg_used;
> -		op.src.u.dma.length = op.src.u.dma.length;
> +		op.dst.u.dma.offset = dst.sg_wa.sg_used;
> +		op.dst.u.dma.length = op.src.u.dma.length;
>   
>   		ret = ccp_perform_passthru(&op);
>   		if (ret) {
> 

