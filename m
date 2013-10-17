Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3JQNt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:49:56 -0400
Received: from smtp-out-233.synserver.de ([212.40.185.233]:1099 "EHLO
	smtp-out-233.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3JQNtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:49:55 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3814
Message-ID: <525FEB7A.5040406@metafoo.de>
Date: Thu, 17 Oct 2013 15:51:54 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>
CC: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
        lgirdwood@gmail.com, broonie@kernel.org, mark.rutland@arm.com,
        alsa-devel@alsa-project.org, linux-doc@vger.kernel.org, tiwai@suse.de,
        b18965@freescale.com, LW@KARO-electronics.de, linux@arm.linux.org.uk,
        b42378@freescale.com, oskar@scara.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, ian.campbell@citrix.com,
        pawel.moll@arm.com, swarren@wwwdotorg.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org, rob@landley.net, r64188@freescale.com,
        shawn.guo@linaro.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [alsa-devel] [PATCHv1 1/8] ALSA: Add SAI SoC Digital Audio Interface
 driver.
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com> <1382000477-17304-2-git-send-email-Li.Xiubo@freescale.com> <525FD4C7.3050806@tabi.org> <525FD65B.3040004@metafoo.de> <525FE48B.7020709@tabi.org> <525FE728.90403@metafoo.de> <525FE815.1040300@tabi.org>
In-Reply-To: <525FE815.1040300@tabi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 03:37 PM, Timur Tabi wrote:
> Lars-Peter Clausen wrote:
>>> >Maybe I've been out of the loop for too long, but why is that a particular
>>> >problem with this driver?
> 
>> It is usually something you'd want to check in general to make sure that you
>> don't have multiple device that access the same iomem region at the same
>> time.
> 
> I understand that, but I'm trying to figure out why of_iomap() is okay for
> hundreds of other drivers, but not this one.  I've used it dozens of times
> myself, without ever worrying about overlapping regions.

The driver would work fine with just of_iomap(). But the resource range
check comes basically for free and it does help to catch errors, so I'd
recommend on using it rather than not using it.

- Lars
