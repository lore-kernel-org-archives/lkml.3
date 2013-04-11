Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934896Ab3DKL5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:57:19 -0400
Received: from canardo.mork.no ([148.122.252.1]:38243 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934132Ab3DKL5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:57:17 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
Organization: m
References: <1365563834.27174.12.camel@joe-AO722>
	<20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
	<20130411021415.GA16118@redhat.com>
Date: Thu, 11 Apr 2013 13:56:54 +0200
In-Reply-To: <20130411021415.GA16118@redhat.com> (Dave Jones's message of
	"Wed, 10 Apr 2013 22:14:15 -0400")
Message-ID: <878v4pwa9l.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:
> On Wed, Apr 10, 2013 at 03:57:51PM -0700, Andrew Morton wrote:
>  > On Tue, 09 Apr 2013 20:17:14 -0700 Joe Perches <joe@perches.com> wrote:
>  > 
>  > > Comparisons of A to true and false are better written
>  > > as A and !A.
>  > > 
>  > > Bleat a message on use.
>  > 
>  > hm.  I'm counting around 1,100 instances of "== true" and "== false".
>  > 
>  > That's a lot of people to shout at.  Is it really worthwhile? 
>  > "foo==true" is a bit of a waste of space but I can't say that I find it
>  > terribly offensive.
>
> It would be interesting to see how many people have historically screwed 
> up and used (!a) when they mean (a) and vice versa, versus spelling
> it out longform.  I'd be surprised if the results weren't skewed
> in favour of the more verbose form.

You have to consider that it is still possible to reverse the operator
even if spelling it out, so you don't really gain anything:

 bjorn@nemi:/usr/local/src/git/linux$ git grep -E '!=\s*(true|false)'|wc -l
 63

and since most of these compare to true, they are also at risk wrt
integers:

 bjorn@nemi:/usr/local/src/git/linux$ git grep -E '!=\s*true'|wc -l
 54

Based on a quick look at a few of these I guess they are mostly OK,
testing against bool values.  But I felt I had to share this little gem
which showed up in drivers/gpu/drm/exynos/exynos_drm_vidi.c:

static int vidi_power_on(struct vidi_context *ctx, bool enable)
{
        struct exynos_drm_subdrv *subdrv = &ctx->subdrv;
        struct device *dev = subdrv->dev;

        DRM_DEBUG_KMS("%s\n", __FILE__);

        if (enable != false && enable != true)
                return -EINVAL;
..


That's taking failsafe to the next step :)


Bjørn
