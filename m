Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbaBFQqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:46:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaBFQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:46:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
Date: Thu, 6 Feb 2014 17:46:29 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, maxime.coquelin@st.com,
        alexandre.torgue@st.com
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <201401312115.33731.arnd@arndb.de> <52F22508.7080706@st.com>
In-Reply-To: <52F22508.7080706@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402061746.30248.arnd@arndb.de>
X-Provags-ID: V02:K0:iHp0EuINXJdcdEgApusqITIUsgBm77TAYPJ5CBIrjJO
 AXM5h8iVrfejQZawm0mKgv5kHrxjAzWx876Sns/YEr+foG8zli
 kksIMYqnMe0qcc3u4ltqk5Rzw4IfWp3/6Bhyr39VpJhIRikTob
 IvTuSVhEGYb8Zt0vgzcVTo3u63iqZ52awjupjeJ3pIy7sAjyJ0
 qejCxtoGG4r74lj0BMSD/oLSIKITniAw+x8uzgfLe08TGjAy+X
 LkYOd6JBbKUdlcnGkAPMr8LeMkHg8GzzrklRm4+V67xr8vvb2b
 su7b1pvUcDOyqAdqb8IxjU6wzpIRVrku+yOZbqKRjyX/7S1UGE
 ZAnDGUAVwtZcqrUK4PKY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 February 2014, srinivas kandagatla wrote:
> Currently l2cc bindings has few optional properties like.
> 
> - arm,data-latency
> - arm,tag-latency
> - arm,dirty-latency
> - arm,filter-ranges
> - interrupts :
> - cache-id-part:
> - wt-override:
> 
> These does not include properties to set "way-size", "associativity",
> "enabling prefetching", "Prefetch drop enable", "prefetch offset",
> "Double linefill" and few more in prefect control register and
> aux-control register.
> 
> This is not just a issue with STi SOCs, having a quick look, I can see
> that few more SOCs have similar requirements to set these properties.
> 
> We could do two things to get l2 setup automatically on STi SOCS.
> 
> 1> Either define these properties case-by-case basic, which might be
> useful for other SOCs too.
> 
> 2> Or Add new compatible string for STi SoCs so that they can
> automatically setup these values in cache-l2x0.c
> 
> Am Ok with either approaches.
> 

I suggested 1 in the past, but the objection that I saw (can't
find the email at the moment) was that the additional settings
are "configuration" rather than "hardware properties". What I'd
really need to know from you is which of properties you listed
as missing above are actually needed for your platform, and whether
they can be classified as hardware specific or just configuration.

	Arnd
