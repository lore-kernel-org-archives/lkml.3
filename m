Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaF3L6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:58:37 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:55045 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbaF3L6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:58:35 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2014 07:58:35 EDT
Message-ID: <53B14E9E.3040505@vmware.com>
Date: Mon, 30 Jun 2014 13:48:46 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christopher Friedt <chrisfriedt@gmail.com>
CC: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com> <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com> <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com>
In-Reply-To: <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 12:19 PM, Christopher Friedt wrote:
>
>
> On Apr 1, 2014 6:00 AM, "Thomas Hellstrom" <thellstrom@vmware.com
> <mailto:thellstrom@vmware.com>> wrote:
> >
> > On 03/28/2014 02:45 AM, Dave Airlie wrote:
> > > On Fri, Mar 28, 2014 at 10:45 AM, Christopher Friedt
> > > <chrisfriedt@gmail.com <mailto:chrisfriedt@gmail.com>> wrote:
> > >> Previously, the vmwgfx_fb driver would allow users to call
> FBIOSET_VINFO, but it would not adjust
> > >> the FINFO properly, resulting in distorted screen rendering. The
> patch corrects that behaviour.
> > >>
> > >> See https://bugs.gentoo.org/show_bug.cgi?id=494794
> <https://urldefense.proofpoint.com/v1/url?u=https://bugs.gentoo.org/show_bug.cgi?id%3D494794&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=hjf3nJVkhVmtW5ub%2FB2AFpKE1pI6pdX%2FvGBFan6861g%3D%0A&s=ca98e09efe2b59ab77e21ab77663e91400437f93d391e28139cb49aa0e21948c>
> for examples.
>
> This correction in vmwgfx appears to have triggered a bug in
> xorg-video-vmware on Ubuntu systems with a custom / unreleased kernel.
>
> If anyone from the X community does not step in, I'll take a look at
> it today.
>
> https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-vmware/+bug/1328898
> <https://urldefense.proofpoint.com/v1/url?u=https://bugs.launchpad.net/ubuntu/%2Bsource/xserver-xorg-video-vmware/%2Bbug/1328898&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=hjf3nJVkhVmtW5ub%2FB2AFpKE1pI6pdX%2FvGBFan6861g%3D%0A&s=56cf4e2efa552bd5eaa2fe7cd82af3f561d717bdd9b6745c84451e1ab6bd05d1>
>
> https://communities.vmware.com/message/2388776
>
+ vmware maintainers

I don't think we can blame video-vmware for this. A kernel driver change
that breaks existing user-space is by definition a kernel driver bug,
regardless whether exisiting user-space is doing something horrendously
stupid.

So the fix must IMO be a kernel driver fix. My initial guess is that
once we set the bytes per line register, it might not be automatically
updated when the screen width is changed, but the documentation is poor.
I see if I can shed some light over this.

/Thomas
