Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaGaRW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:22:58 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:46436 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaGaRWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <1404863367-20413-1-git-send-email-vpalatin@chromium.org>
References: <CAP_ceTxk=OE3UVhNKk+WV7EG3E9Z0cOH4tZBU210Awa15OOjgw@mail.gmail.com>
 <1404863367-20413-1-git-send-email-vpalatin@chromium.org>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Thu, 31 Jul 2014 10:22:34 -0700
X-Google-Sender-Auth: 3IoJoWrHE2SrLxRt4o1i68AaS_M
Message-ID: <CAP_ceTwPCfNQvacs3p5M0nnJr060uLJOx=ieb5jx6rCxAEXmSA@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] V4L: Add camera pan/tilt speed controls
To: Hans de Goede <hdegoede@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olofj@chromium.org>,
        Pawel Osciak <posciak@chromium.org>, Zach Kuznia <zork@chromium.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ...
Any opinion on adding those new controls ? since re-using the existing
relative ones was seen as too twisted.

Thanks,
-- 
Vincent


On Tue, Jul 8, 2014 at 4:49 PM, Vincent Palatin <vpalatin@chromium.org> wrote:
> The V4L2_CID_PAN_SPEED and V4L2_CID_TILT_SPEED controls allow to move the
> camera by setting its rotation speed around its axis.
>
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> ---
>  Documentation/DocBook/media/v4l/compat.xml   | 10 ++++++++++
>  Documentation/DocBook/media/v4l/controls.xml | 21 +++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
>  include/uapi/linux/v4l2-controls.h           |  2 ++
>  4 files changed, 35 insertions(+)
>
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index eee6f0f..21910e9 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2545,6 +2545,16 @@ fields changed from _s32 to _u32.
>        </orderedlist>
>      </section>
>
> +    <section>
> +      <title>V4L2 in Linux 3.17</title>
> +      <orderedlist>
> +       <listitem>
> +         <para>Added <constant>V4L2_CID_PAN_SPEED</constant> and
> + <constant>V4L2_CID_TILT_SPEED</constant> camera controls.</para>
> +       </listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
>
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 47198ee..cdf97f0 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3914,6 +3914,27 @@ by exposure, white balance or focus controls.</entry>
>           </row>
>           <row><entry></entry></row>
>
> +         <row>
> +           <entry spanname="id"><constant>V4L2_CID_PAN_SPEED</constant>&nbsp;</entry>
> +           <entry>integer</entry>
> +         </row><row><entry spanname="descr">This control turns the
> +camera horizontally at the specific speed. The unit is undefined. A
> +positive value moves the camera to the right (clockwise when viewed
> +from above), a negative value to the left. A value of zero does not
> +cause or stop the motion.</entry>
> +         </row>
> +         <row><entry></entry></row>
> +
> +         <row>
> +           <entry spanname="id"><constant>V4L2_CID_TILT_SPEED</constant>&nbsp;</entry>
> +           <entry>integer</entry>
> +         </row><row><entry spanname="descr">This control turns the
> +camera vertically at the specified speed. The unit is undefined. A
> +positive value moves the camera up, a negative value down. A value of
> +zero does not cause or stop the motion.</entry>
> +         </row>
> +         <row><entry></entry></row>
> +
>         </tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 55c6832..57ddaf4 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -787,6 +787,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>         case V4L2_CID_AUTO_FOCUS_STOP:          return "Auto Focus, Stop";
>         case V4L2_CID_AUTO_FOCUS_STATUS:        return "Auto Focus, Status";
>         case V4L2_CID_AUTO_FOCUS_RANGE:         return "Auto Focus, Range";
> +       case V4L2_CID_PAN_SPEED:                return "Pan, Speed";
> +       case V4L2_CID_TILT_SPEED:               return "Tilt, Speed";
>
>         /* FM Radio Modulator control */
>         /* Keep the order of the 'case's the same as in videodev2.h! */
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 2ac5597..5576044 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -745,6 +745,8 @@ enum v4l2_auto_focus_range {
>         V4L2_AUTO_FOCUS_RANGE_INFINITY          = 3,
>  };
>
> +#define V4L2_CID_PAN_SPEED                     (V4L2_CID_CAMERA_CLASS_BASE+32)
> +#define V4L2_CID_TILT_SPEED                    (V4L2_CID_CAMERA_CLASS_BASE+33)
>
>  /* FM Modulator class control IDs */
>
> --
> 2.0.0.526.g5318336
>
