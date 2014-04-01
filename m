Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaDAK0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:26:35 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42453 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaDAK0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:26:33 -0400
MIME-Version: 1.0
In-Reply-To: <53398379.8000203@linux.vnet.ibm.com>
References: <20140328073344.26823.32931.stgit@bahia.local>
	<53398379.8000203@linux.vnet.ibm.com>
Date: Tue, 1 Apr 2014 12:26:32 +0200
X-Google-Sender-Auth: yInnvguAOmnvD9COXWJwMq20i_s
Message-ID: <CAMuHMdXXELjK-t4k025uRE3QPsMiYR9KevtEnq_k32m-4g+fPg@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc/le: enable RTAS events support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Greg Kurz <gkurz@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Breeds <tony@bakeyournoodle.com>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 5:02 PM, Nathan Fontenot
<nfont@linux.vnet.ibm.com> wrote:
>  struct rtas_error_log {
> -       unsigned long version:8;                /* Architectural version */
> -       unsigned long severity:3;               /* Severity level of error */
> -       unsigned long disposition:2;            /* Degree of recovery */
> -       unsigned long extended:1;               /* extended log present? */
> -       unsigned long /* reserved */ :2;        /* Reserved for future use */
> -       unsigned long initiator:4;              /* Initiator of event */
> -       unsigned long target:4;                 /* Target of failed operation */
> -       unsigned long type:8;                   /* General event or error*/
> -       unsigned long extended_log_length:32;   /* length in bytes */
> -       unsigned char buffer[1];                /* Start of extended log */
> +       /* Byte 0 */
> +       uint8_t         version;                /* Architectural version */
> +
> +       /* Byte 1 */
> +       uint8_t         severity;
> +       /* XXXXXXXX
> +        * XXX          3: Severity level of error
> +        *    XX        2: Degree of recovery
> +        *      X       1: Extended log present?
> +        *       XX     2: Reserved
> +        */
> +
> +       /* Byte 2 */
> +       uint8_t         :8;
> +       /* XXXXXXXX
> +        * XXXX         4: Initiator of event
> +        *     XXXX     4: Target of failed operation
> +        */
> +       uint8_t         type;                   /* General event or error*/
> +       uint32_t        extended_log_length;    /* length in bytes */

Now the bitfields are gone, things like the above can become __be32,
so we get extra type checking from sparse ("make C=1").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
