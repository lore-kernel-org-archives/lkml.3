Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3BZSLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:11:33 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:38186 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3BZSLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130226173514.GA24136@kroah.com>
References: <CAPM=9txjG5rohsNbme=myrX+-Z5eucpEXYQMWqPQqN=5dNze8g@mail.gmail.com>
	<CAPM=9tw_vfESbbH4dD9z8mAYVYcwmVs=n4BrRz4XBj1Rw1qrkw@mail.gmail.com>
	<20130225223243.GA18744@kroah.com>
	<20130226034545.GA1089@kroah.com>
	<20130226173514.GA24136@kroah.com>
Date: Tue, 26 Feb 2013 18:11:31 +0000
Message-ID: <CAAMvbhFTNmUS-usRZKBEqp_YrpxDhckj9tdTtC+m_5EnO+UECw@mail.gmail.com>
Subject: Re: resume fails to light display on Macbook Pro Retina on 3.8-rc1
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>, Martin Peres <martin.peres@labri.fr>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2013 17:35, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Feb 25, 2013 at 07:45:45PM -0800, Greg KH wrote:
>> On Mon, Feb 25, 2013 at 02:32:43PM -0800, Greg KH wrote:
>> > On Mon, Feb 25, 2013 at 04:06:02PM +1000, Dave Airlie wrote:
>> > > On Mon, Feb 25, 2013 at 3:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > > > Hi Ben,
>> > > >
>> > > > My Macbook Pro Retina fails to resume properly on 3.8.  I tracked this
>> > > > down to commit 6c5a04249d7afeea3e0ed971e7813f84e29a1706 (drm/nvd0/disp:
>> > > > move link training helpers into core as display methods)
>> > > >
>> > > > Anything I can try to help solve this?
>> > > >
>> > > > Note, I'm using the Intel driver as the main controller for this laptop,
>> > > > well, I think I am, my xorg log is attached.
>> > >
>> > > No you are using the nvidia, the efi always boots nvidia enabled now.
>> >
>> > Really?  When did that change?  I thought I wanted to be using the Intel
>> > chip to save battery life.
>> >
>> > > btw I just tested my drm-next tree on mine and it resumed the display
>> > > fine, something oopsed a few seconds later that I haven't tracked down
>> > >
>> > > git://git.freedesktop.org/~airlied/linux drm-next
>> > >
>> > > I'll be sending it to Linus this evening or tomorrow morning, once I
>> > > fix my tree.
>> >
>> > Ok, I'll test again when it hits Linus's tree, and if that works, it
>> > would be good to try to work out what patch fixes it to get them into
>> > the 3.8-stable series so that others don't run into the same problem.
>>
>> I've tested Linus's tree now (I'm guessing it has all of your changes in
>> it), and it works!
>>
>> I see a bunch of patches marked for the stable branch, so I'll try those
>> out and see if they fix the problem.  If not, I'll let you and Ben know.
>
> I've applied the radeon patches tagged for -stable and tested that on
> 3.8.0, but that doesn't solve the resume problem.  Any ideas of anything
> else I can do to test this?  Doing a "backwards" git-bisect is a pain,
> but I guess I can do that to try to track down what patch fixed this, if
> that's the only idea people have...
>

If it helps, I have a similar resume problem here.
3.7.8 good
3.8.0 bad

Laptop with no nvidia, no amd graphics, just Intel Graphics 4000, 3rd
Gen I5 CPU.
