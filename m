Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3ECEkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:40:39 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:44482
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab3ECEkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:40:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z21eIz9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275dha509lz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fhbe9i1155h)
From: Jain Priyanka-B32167 <B32167@freescale.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: RE: [ANNOUNCE] 3.8.10-rt6
Thread-Topic: [ANNOUNCE] 3.8.10-rt6
Thread-Index: AQHORRXivDCuEOwOTU6Fg0do3WswAZjy5bdg
Date: Fri, 3 May 2013 04:40:33 +0000
Message-ID: <AC83832D6324604BB08FAE5A33553F190B360375@039-SN2MPN1-013.039d.mgd.msft.net>
References: <20130429201202.GB7979@linutronix.de>
In-Reply-To: <20130429201202.GB7979@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.131]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r434f64V009431

Hello Sebastian,

It is mentioned below that SLxB is broken.
I assume it means bit SLUB and SLAB is broken?
Can you please share the error-details/logs/scenario/steps-to-reproduce.

Regards
Priyanka

> -----Original Message-----
> From: linux-rt-users-owner@vger.kernel.org [mailto:linux-rt-users-
> owner@vger.kernel.org] On Behalf Of Sebastian Andrzej Siewior
> Sent: Tuesday, April 30, 2013 1:42 AM
> To: linux-rt-users
> Cc: LKML; Thomas Gleixner; rostedt@goodmis.org
> Subject: [ANNOUNCE] 3.8.10-rt6
> 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.8.10-rt6 release.
> 
> changes since v3.8.10-rt5:
> - the i915 compiles again after I broke it in the last release. A patch
>   was sent by Carsten Emde.
> 
> Known issues:
> 
>     - SLxB is broken on PowerPC.
>     - suspend / resume seems to program program the timer wrong and wait
>       ages until it continues.
> 
> The delta patch against v3.8.10-rt5 is appended below and can be found
> here:
> 
>   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-
> 3.8.10-rt5-rt6.patch.xz
> 
> The RT patch against 3.8.9 can be found here:
> 
>   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.10-
> rt6.patch.xz
> 
> The split quilt queue is available at:
> 
>   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.10-
> rt6.tar.xz
> 
> Sebastian
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> index 81125de..eabd3dd 100644
> --- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> @@ -814,6 +814,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void
> *data,
>  	struct intel_ring_buffer *ring;
>  	u32 ctx_id = i915_execbuffer2_get_context_id(*args);
>  	u32 exec_start, exec_len;
> +	u32 seqno;
>  	u32 mask;
>  	u32 flags;
>  	int ret, mode, i;
> @@ -1068,7 +1069,8 @@ i915_gem_do_execbuffer(struct drm_device *dev, void
> *data,
>  			goto err;
>  	}
> 
> -	trace_i915_gem_ring_dispatch(ring, intel_ring_get_seqno(ring),
> flags);
> +	seqno = intel_ring_get_seqno(ring);
> +	trace_i915_gem_ring_dispatch(ring, seqno, flags);
>  	i915_trace_irq_get(ring, seqno);
> 
>  	i915_gem_execbuffer_move_to_active(&objects, ring); diff --git
> a/localversion-rt b/localversion-rt index 0efe7ba..8fc605d 100644
> --- a/localversion-rt
> +++ b/localversion-rt
> @@ -1 +1 @@
> --rt5
> +-rt6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users"
> in the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
