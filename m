Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaLUB7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 20:59:25 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37573 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbaLUB7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 20:59:23 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAFo99gYCGS7C358BgLBG+3m-tfRx9F_d=uVFS++rNBqRkhQYNA@mail.gmail.com>
References: <1419114917-12029-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <104C68D6-95CC-4268-B08D-2C48474EC09C@md.metrocast.net> <CAFo99gYCGS7C358BgLBG+3m-tfRx9F_d=uVFS++rNBqRkhQYNA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] media: pci: cx18: cx18-alsa-mixer.c: Remove some unused functions
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 20 Dec 2014 20:58:06 -0500
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <CA84B402-23C7-4D88-8AB6-DCD5DC3E5529@md.metrocast.net>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-21_01:2014-12-19,2014-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1412210021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 20, 2014 8:17:05 PM EST, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>2014-12-21 1:06 GMT+01:00 Andy Walls <awalls@md.metrocast.net>:
>> On December 20, 2014 5:35:17 PM EST, Rickard Strandqvist
><rickard_strandqvist@spectrumdigital.se> wrote:
>>>Removes some functions that are not used anywhere:
>>>snd_cx18_mixer_tv_vol_get() snd_cx18_mixer_tv_vol_info()
>>>snd_cx18_mixer_tv_vol_put()
>>>
>>>This was partially found by using a static code analysis program
>called
>>>cppcheck.
>>>
>>>Signed-off-by: Rickard Strandqvist
>>><rickard_strandqvist@spectrumdigital.se>
>>>---
>>>drivers/media/pci/cx18/cx18-alsa-mixer.c |   62
>>>------------------------------
>>> 1 file changed, 62 deletions(-)
>>>
>>>diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c
>>>b/drivers/media/pci/cx18/cx18-alsa-mixer.c
>>>index 341bddc..e7b0a1f 100644
>>>--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
>>>+++ b/drivers/media/pci/cx18/cx18-alsa-mixer.c
>>>@@ -69,68 +69,6 @@ static inline int cx18_av_vol_to_dB(int v)
>>>       return (v >> 9) - 119;
>>> }
>>>
>>>-static int snd_cx18_mixer_tv_vol_info(struct snd_kcontrol *kcontrol,
>>>-                                    struct snd_ctl_elem_info *uinfo)
>>>-{
>>>-      uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
>>>-      uinfo->count = 1;
>>>-      /* We're already translating values, just keep this control in
>dB */
>>>-      uinfo->value.integer.min  = -96;
>>>-      uinfo->value.integer.max  =   8;
>>>-      uinfo->value.integer.step =   1;
>>>-      return 0;
>>>-}
>>>-
>>>-static int snd_cx18_mixer_tv_vol_get(struct snd_kcontrol *kctl,
>>>-                                   struct snd_ctl_elem_value *uctl)
>>>-{
>>>-      struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
>>>-      struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
>>>-      struct v4l2_control vctrl;
>>>-      int ret;
>>>-
>>>-      vctrl.id = V4L2_CID_AUDIO_VOLUME;
>>>-      vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
>>>-
>>>-      snd_cx18_lock(cxsc);
>>>-      ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
>>>-      snd_cx18_unlock(cxsc);
>>>-
>>>-      if (!ret)
>>>-              uctl->value.integer.value[0] =
>cx18_av_vol_to_dB(vctrl.value);
>>>-      return ret;
>>>-}
>>>-
>>>-static int snd_cx18_mixer_tv_vol_put(struct snd_kcontrol *kctl,
>>>-                                   struct snd_ctl_elem_value *uctl)
>>>-{
>>>-      struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
>>>-      struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
>>>-      struct v4l2_control vctrl;
>>>-      int ret;
>>>-
>>>-      vctrl.id = V4L2_CID_AUDIO_VOLUME;
>>>-      vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
>>>-
>>>-      snd_cx18_lock(cxsc);
>>>-
>>>-      /* Fetch current state */
>>>-      ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
>>>-
>>>-      if (ret ||
>>>-          (cx18_av_vol_to_dB(vctrl.value) !=
>uctl->value.integer.value[0]))
>>>{
>>>-
>>>-              /* Set, if needed */
>>>-              vctrl.value =
>dB_to_cx18_av_vol(uctl->value.integer.value[0]);
>>>-              ret = v4l2_subdev_call(cx->sd_av, core, s_ctrl,
>&vctrl);
>>>-              if (!ret)
>>>-                      ret = 1; /* Indicate control was changed w/o
>error */
>>>-      }
>>>-      snd_cx18_unlock(cxsc);
>>>-
>>>-      return ret;
>>>-}
>>>-
>>>
>>>/* This is a bit of overkill, the slider is already in dB internally
>*/
>>>static DECLARE_TLV_DB_SCALE(snd_cx18_mixer_tv_vol_db_scale, -9600,
>100,
>>>0);
>>
>> Really?  Did you try to compile the file after this patch?
>>
>>
>http://git.linuxtv.org/cgit.cgi/media_tree.git/tree/drivers/media/pci/cx18/cx18-alsa-mixer.c#n143
>>
>> They are referenced later in the same file.
>>
>> This is only half a fix.
>>
>>  You can either remove the cx18-alsa-mixer.* files and from the build
>system, or even better,you can hook-up and initialize these callbacks
>with alsa so alsa mixer controls show up for cx18.  :)
>>
>
>
>
>Hi
>
>Ok sorry :-(
>
>Sure, I compile everything as allyesconfig, allmodconfig and
>allnoconfig.
>
>So snd_cx18_mixer_tv_volume_info is the same as
>snd_cx18_mixer_tv_vol_info then.
>
>Would gladly done something a little more concrete.
>But first I want to see if as I can go through all of the
>approximately 2000 functions that are not in use.
>
>
>Kind regards
>Rickard Strandqvist

Yes they are supposed to be the same.  It is dead code with typographical errors. So it is probably not even in the Makefile.

Regards,
Andy
