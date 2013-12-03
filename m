Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3LCPFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:05:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3LCPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:05:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: haver@linux.vnet.ibm.com
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
Date: Tue, 3 Dec 2013 16:05:38 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com> <20131203143010.GB3521@kroah.com> <1386082011.29309.2.camel@oc7383187364.ibm.com>
In-Reply-To: <1386082011.29309.2.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312031605.38972.arnd@arndb.de>
X-Provags-ID: V02:K0:ndWR9KSWGpHNrQZG7QBxgIEND/gSlMvDHBDj9sFBUdy
 tUu1sFlitFR72nGQzMpnL5ll3i2aPY+ErFknKtUj1/hrGMACCn
 1YkqJk/YHEk9RQTQWcK1/dxFXAIcpDfcw7bn6VdQ9720KAlakf
 dVYmcNfv1JoGOWt+Br3Pl+ty123LU3WNLMezeZxkSLGeqHzqKS
 tsSTFrJ63rgsdkLgD/Wcx13M2Jnjgj+uj9V6ON9srhhD9AO1Ly
 /WAlsz6JMbXg+N1ImcrM5vFHtevpbO416fWfg1pnQ0+DaCY2PP
 natQmM5glwHKP0iMSDqSlL0vtFZgUI/3jolRaXWhexSBTnpc+q
 zRSrdO3CFKEPoDUsNS6Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013, Frank Haverkamp wrote:
> Ohh, sorry __u64 of course:
> 
> /* common struct for chip image exchange */
> struct genwqe_bitstream {
>         __u64 data_addr;                /* pointer to image data */
>         __u32 size;                     /* size of image file */
>         __u32 crc;                      /* crc of this image */
>         __u8  partition;                /* '0', '1', or 'v' */
>         __u64 target_addr;              /* starting address in Flash */
>         __u8  uid;                      /* 1=host/x=dram */
> 
>         __u64 slu_id;                   /* informational/sim: SluID */
>         __u64 app_id;                   /* informational/sim: AppID */
> 
>         __u16 retc;                     /* returned from processing */
>         __u16 attn;                     /* attention code from
> processing */
>         __u32 progress;                 /* progress code from processing
> */
> };
> 
> and than I do in my userspace application:
> 
>         load.data_addr = (unsigned long)buf;
> 
> Is that ok, or must I consider more?
> 

I haven't followed the recent discussions, jumping into the middle here:
The structure above is not safe for a generic ioctl interface because it
has different padding on x86-32 and x86-64, where __u64 has different
alignment.

You can try to avoid the implicit padding by sorting the members by size,
by making some members larger or by adding explicit padding.

	Arnd
