Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3J3Uq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:46:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab3J3UqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:46:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 2/2] misc: atmel_pwm: set initcall level to subsys
Date: Wed, 30 Oct 2013 21:46:17 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com> <20131029232249.GA20476@kroah.com> <20131030110705.GA29813@localhost>
In-Reply-To: <20131030110705.GA29813@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310302146.18248.arnd@arndb.de>
X-Provags-ID: V02:K0:QYC/kS2mCqCbOq3v+5McssUpVrH95+hEHkgLDo+eK0E
 Z+oxVvf5OyeHkvyntgVVy3D3X5tmFLMVx6pnzzTTejveRazIdC
 UOJzdL2F+J6NBRX1lwkvSn59CF6R/QawejiweAjBXqrluMZL9G
 +E1VG+qMo2Zj5pSmnNWNHhZdRxerSoDXU1D3NdmxKuA+7lTyhy
 1oAHFVbovFy/QBIlF0jkp/bTjLU4bRe2CsGZPU9qRklh4zJcIp
 GRduauKcxU4Gj8k+2vUQLnTODkR3Qti8r3pVYwPa9PlU9vbGZT
 tCv51OjRRL7ZQ6s/SXiEorxpqGVvTU0Oz6WsZqjz5XTFMgd9XM
 MuzkEat9nzFTe8mAnY/Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 October 2013, Johan Hovold wrote:
> > I really hate this type of patch, as it's papering over the real
> > problem.  What happens when someone else moves their driver to this
> > level?  Then you are back to the original problem.
> 
> Yes, it's crude, but it's currently the only way to express a preferred
> probe order.

Does the same problem occur with the generic PWM subsystem?

The atmel_pwm driver apparently is the last PWM driver that has
not been converted to the generic subsystem yet. Doing that would
also let us drop the atmel-pwm-bl driver in favor of the generic
backlight.

	Arnd
