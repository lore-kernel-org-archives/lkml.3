Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaDWMNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:13:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaDWMNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:13:01 -0400
Message-ID: <1398255179.32091.1.camel@linux-fkkt.site>
Subject: Re: [PATCH v2 01/24] input: Add ff-memless-next module
From: Oliver Neukum <oneukum@suse.de>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Date: Wed, 23 Apr 2014 14:12:59 +0200
In-Reply-To: <1398175209-9565-2-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
	 <1398175209-9565-2-git-send-email-madcatxster@devoid-pointer.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 15:59 +0200, Michal Malý wrote:
> +/* Some devices might have a limit on how many uncombinable effects
> + * can be played at once */
> +static int mlnx_upload_conditional(struct mlnx_device *mlnxdev,
> +                                  const struct ff_effect *effect)
> +{
> +       struct mlnx_effect_command ecmd = {
> +               .cmd = MLNX_UPLOAD_UNCOMB,
> +               .u.uncomb.id = effect->id,
> +               .u.uncomb.effect = effect
> +       };
> +       return mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private,
> &ecmd);
> +}
> +

This mean you are building the structure on the stack

1. Are you sure nobody retains a reference?
2. That is needlessly inefficient

	Regards
		Oliver


