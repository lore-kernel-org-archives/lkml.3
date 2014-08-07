Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaHGCTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 22:19:34 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40934 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaHGCTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 22:19:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAP_ceTwdDB76y9V-Zi2fwRwwVFiRHnAGhjiD1AJBsn21vQ9W4Q@mail.gmail.com>
References: <CAP_ceTxk=OE3UVhNKk+WV7EG3E9Z0cOH4tZBU210Awa15OOjgw@mail.gmail.com>
 <1404863367-20413-1-git-send-email-vpalatin@chromium.org> <CACHYQ-o0FWSSHRmNhQ+id2uvHHWqVzQXQpmu31_e4OmDeVd_CQ@mail.gmail.com>
 <CAP_ceTwdDB76y9V-Zi2fwRwwVFiRHnAGhjiD1AJBsn21vQ9W4Q@mail.gmail.com>
From: Pawel Osciak <posciak@chromium.org>
Date: Thu, 7 Aug 2014 11:18:50 +0900
Message-ID: <CACHYQ-rtHfVmF4DstxhWe0zWNH3ujjniVBwONBGW3f4Uw=rvkg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] V4L: Add camera pan/tilt speed controls
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>, Zach Kuznia <zork@chromium.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 12:10 AM, Vincent Palatin <vpalatin@chromium.org> wrote:
>
> On Sun, Aug 3, 2014 at 10:52 PM, Pawel Osciak <posciak@chromium.org> wrote:
> > This looks good to me in general (with one comment below). I don't think we
> > can easily implement current V4L2 pan and tilt controls that are for
> > movement by a specified amount in terms of UVC pan/tilt speed controls,
> > which only let us set speed and direction...
> >
> > On Wed, Jul 9, 2014 at 8:49 AM, Vincent Palatin <vpalatin@chromium.org>
> > wrote:
> >>
> >> The V4L2_CID_PAN_SPEED and V4L2_CID_TILT_SPEED controls allow to move the
> >> camera by setting its rotation speed around its axis.
> >>
> >> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> >>
> >> ---
> >>  Documentation/DocBook/media/v4l/compat.xml   | 10 ++++++++++
> >>  Documentation/DocBook/media/v4l/controls.xml | 21 +++++++++++++++++++++
> >>  drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
> >>  include/uapi/linux/v4l2-controls.h           |  2 ++
> >>  4 files changed, 35 insertions(+)
> >>
> >> diff --git a/Documentation/DocBook/media/v4l/compat.xml
> >> b/Documentation/DocBook/media/v4l/compat.xml
> >> index eee6f0f..21910e9 100644
> >> --- a/Documentation/DocBook/media/v4l/compat.xml
> >> +++ b/Documentation/DocBook/media/v4l/compat.xml
> >> @@ -2545,6 +2545,16 @@ fields changed from _s32 to _u32.
> >>        </orderedlist>
> >>      </section>
> >>
> >> +    <section>
> >> +      <title>V4L2 in Linux 3.17</title>
> >> +      <orderedlist>
> >> +       <listitem>
> >> +         <para>Added <constant>V4L2_CID_PAN_SPEED</constant> and
> >> + <constant>V4L2_CID_TILT_SPEED</constant> camera controls.</para>
> >> +       </listitem>
> >> +      </orderedlist>
> >> +    </section>
> >> +
> >>      <section id="other">
> >>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> >>
> >> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> >> b/Documentation/DocBook/media/v4l/controls.xml
> >> index 47198ee..cdf97f0 100644
> >> --- a/Documentation/DocBook/media/v4l/controls.xml
> >> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >> @@ -3914,6 +3914,27 @@ by exposure, white balance or focus
> >> controls.</entry>
> >>           </row>
> >>           <row><entry></entry></row>
> >>
> >> +         <row>
> >> +           <entry
> >> spanname="id"><constant>V4L2_CID_PAN_SPEED</constant>&nbsp;</entry>
> >> +           <entry>integer</entry>
> >> +         </row><row><entry spanname="descr">This control turns the
> >> +camera horizontally at the specific speed. The unit is undefined. A
> >> +positive value moves the camera to the right (clockwise when viewed
> >> +from above), a negative value to the left. A value of zero does not
> >> +cause or stop the motion.</entry>
> >
> >
> > How do we stop/start?
>
> As mentioned in the last sentence of the paragraph above, setting 0
> stops the movement.
> setting non-zero value starts it if needed.
>

The sentence says "A value of zero does *not* cause or stop the
motion.". Perhaps "not" is a typo then?
