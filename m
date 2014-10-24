Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaJXUgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:36:25 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:50085 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaJXUgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <20141024201138.GL3729@sirena.org.uk>
References: <1414178111-19525-1-git-send-email-balbi@ti.com>
	<20141024201138.GL3729@sirena.org.uk>
Date: Fri, 24 Oct 2014 16:36:24 -0400
Message-ID: <CAF6AEGssn23wSaSCY-MH+CUk1YD2g7Ld+rejQq0BSHUAcXgZEQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: stub out devm_regulator_get_exclusive
From: Rob Clark <robdclark@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, David Brown <davidb@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 4:11 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Oct 24, 2014 at 02:15:11PM -0500, Felipe Balbi wrote:
>> If we don't stup that call out, we will have
>> build failures for any drivers using that function
>> when .config happens to have CONFIG_REGULATOR=n.
>>
>> One such case below, found with randconfig
>>
>> drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c: In function ‘mdp4_kms_init’:
>> drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:2: error: implicit declaration \
>
> As previously and repeatedly reported the regulator usage in this driver
> appears extremely problematic, among these problems is that it almost
> certainly has no sensible reason to be using regulator_get_exclusive()
> or any variant of it.  Sadly every time it's been raised with the video
> people they've completely ignored the mail so here we are.

oh, looks like a case of overambitious mailing list filter rules.. I
did not see the earlier threads on the topic.

iirc, I was using _get_exclusive() in a few places where I wanted to
be sure not to get dummy-regulator in cases where I should
-EPROBE_DEFER instead (since probe order with DT is slightly
hilarious, and since I depend on a few other drivers I end up
deferring at least a couple times at boot)... I don't quite remember
the details.  But afaict regulator_get() still allows dummy-regulator,
which is what I specifically don't want.

If you have a recommendation for a better way, I am all ears.

BR,
-R

> Right now not having the stub seems to only be affecting buggy users
> (which given the use cases for _exclusive() isn't *that* surprising) so
> I'm more inclined to leave this there in the hope that the users get
> fixed or we can at least get some sort of dialogue with the relevant
> maintainers.
