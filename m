Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaEWIav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:30:51 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2623 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaEWIas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:30:48 -0400
Message-ID: <537F070D.1090008@xs4all.nl>
Date: Fri, 23 May 2014 10:30:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 00/49] DaVinci: vpif: upgrade with v4l helpers and
 v4l compliance fixes
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thanks for this patch series, it looks good to me and I'll make a pull
request for this.

I did find a few issues, but they are all pre-existing problems, so they
can be fixed in follow-up patches.

I'll comment on those in the relevant patches. Since display and capture are
so similar I will only comment on the display patches, but it's valid for
both.

Regards,

	Hans

On 05/16/2014 03:33 PM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Hi,
> 
> This patch series upgrades the vpif capture & display
> driver with the all the helpers provided by v4l, this makes
> the driver much simpler and cleaner. This also includes few
> checkpatch issues.
> 
> Changes for v2:
> a> Added a copyright.
> b> Dropped buf_init() callback from vb2_ops.
> c> Fixed enabling & disabling of interrupts in case of HD formats.
> 
> Changes for v3:
> a> Fixed review comments pointed by Hans.
> 
> Changes for v4: Rebased the patches on media tree.
> 
> Changes for v5: Split up the patches
> 
> Following is the output of v4l-compliance for capture:
> ------------------------------------------------------
> 
> ./v4l2-compliance -d /dev/video0 -i 0 -s -v --expbuf-device=2
> 
> Driver Info:
>         Driver name   : vpif_capture
>         Card type     : DA850/OMAP-L138 Video Capture
>         Bus info      : platform:vpif_capture
>         Driver version: 3.15.0
>         Capabilities  : 0x84000001
>                 Video Capture
>                 Streaming
>                 Device Capabilities
>         Device Caps   : 0x04000001
>                 Video Capture
>                 Streaming
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 0 Private Controls: 0
> 
>         Format ioctls:
>                 info: found 1 formats for buftype 1
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 fail: v4l2-test-formats.cpp(1003): cap->readbuffers
>                 test VIDIOC_G/S_PARM: FAIL
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>                 info: test buftype Video Capture
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>         test VIDIOC_EXPBUF: OK
>         test read/write: OK (Not Supported)
>             Video Capture:
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 145.509130s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 145.549125s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 145.589148s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 145.629106s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 145.669110s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 145.709102s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 145.749099s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 145.789128s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 145.829116s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 145.869105s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 145.909100s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 145.949098s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 145.989086s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 146.029083s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 146.069083s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 146.109074s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 146.149074s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 146.189100s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 146.229077s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 146.269078s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 146.309075s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 146.349070s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 146.389060s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 146.429052s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 146.469053s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 146.509047s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 146.549045s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 146.589072s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 146.629047s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 146.669051s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 146.709046s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 146.749043s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 146.789033s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 146.829023s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 146.869025s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 146.909018s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 146.949029s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 146.989046s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 147.029021s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 147.069024s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 147.109019s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 147.149004s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 147.189006s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 147.228998s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 147.268996s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 147.308996s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 147.349004s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 147.389019s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 147.429000s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 147.468999s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 147.509004s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 147.548979s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 147.588982s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 147.628973s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 147.668976s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 147.708968s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 147.748979s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 147.788991s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 147.828972s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 147.868969s
>             Video Capture (polling):
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 147.908969s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 147.948952s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 147.988955s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 148.028946s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 148.068946s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 148.108954s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 148.148955s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 148.188973s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 148.228948s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 148.268943s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 148.308949s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 148.348928s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 148.388927s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 148.428918s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 148.468918s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 148.508923s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 148.548919s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 148.588946s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 148.628923s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 148.668917s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 148.708902s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 148.748899s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 148.788901s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 148.828895s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 148.868892s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 148.908897s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 148.948898s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 148.988920s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 149.028892s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 149.068893s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 149.108876s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 149.148873s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 149.188875s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 149.228867s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 149.268875s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 149.308870s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 149.348870s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 149.388870s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 149.428891s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 149.468893s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 149.508849s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 149.548845s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 149.588849s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 149.628842s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 149.668855s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 149.708844s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 149.748846s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 149.788868s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 149.828842s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 149.868826s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 149.908823s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 149.948821s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 149.988821s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 150.028817s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 150.068824s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 150.108818s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 150.148818s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 150.188839s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 150.228808s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 150.268798s
>         test MMAP: OK
>                 fail: v4l2-test-buffers.cpp(936): buf.qbuf(q)
>                 fail: v4l2-test-buffers.cpp(976): setupUserPtr(node, q)
>         test USERPTR: FAIL
>             Video Output:
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.234735s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.268098s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 165.301503s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.334846s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.368202s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 165.401594s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.434960s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.468320s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 165.501709s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.535041s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.568428s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 165.601811s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.635146s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.668514s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 165.701913s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.735260s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.768617s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 165.802007s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.835367s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.868732s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 165.902120s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 165.935451s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 165.968837s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.002223s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.035566s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.068923s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.102327s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.135667s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.169023s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.202423s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.235785s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.269146s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.302535s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.335862s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.369252s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.402637s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.435978s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.469335s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.502705s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.536087s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.569454s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.602817s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.636177s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.669557s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.702934s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.736280s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.769648s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.803053s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.836396s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.869753s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 166.903122s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 166.936499s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 166.969870s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.003251s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.036591s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.069975s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.103363s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.136702s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.170112s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.203462s
>             Video Output (polling):
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.236804s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.270175s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.303533s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.336914s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.370269s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.403661s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.436999s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.470388s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.503774s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.537117s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.570511s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.603874s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.637222s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.670603s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.703944s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.737326s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.770694s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.804083s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.837412s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.870809s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 167.904185s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 167.937526s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 167.970900s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.004285s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.037632s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.070993s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.104382s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.137735s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.171104s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.204492s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.237822s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.271190s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.304596s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.337941s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.371310s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.404665s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.438046s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.471408s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.504794s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.538130s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.571517s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.604904s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.638234s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.671610s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.704984s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.738352s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.771725s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.805080s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.838459s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.871822s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 168.905165s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 168.938547s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 168.971931s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 169.005319s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 169.038649s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 169.072021s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 169.105420s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 169.138776s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 169.172136s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 169.205492s
>         test DMABUF: OK
> 
> Total: 41, Succeeded: 40, Failed: 1, Warnings: 0
> 
> Following is the output of v4l-compliance for display:
> ------------------------------------------------------
> 
> ./v4l2-compliance -d /dev/video2 -o 0 -s -v --expbuf-device=0 
> 
> Driver Info:
>         Driver name   : vpif_capture
>         Card type     : DA850/OMAP-L138 Video Capture
>         Bus info      : platform:vpif_capture
>         Driver version: 3.15.0
>         Capabilities  : 0x84000001
>                 Video Capture
>                 Streaming
>                 Device Capabilities
>         Device Caps   : 0x04000001
>                 Video Capture
>                 Streaming
> 
> Compliance test for device /dev/video2 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 2 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test output 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 0 Private Controls: 0
> 
>         Format ioctls:
>                 info: found 1 formats for buftype 2
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Test output 1:
> 
>         Control ioctls:
>                 test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 0 Private Controls: 0
> 
>         Format ioctls:
>                 info: found 1 formats for buftype 2
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>                 info: test buftype Video Output
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>         test VIDIOC_EXPBUF: OK
>         test read/write: OK (Not Supported)
>             Video Output:
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 203.197959s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 203.231346s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 203.264708s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 203.298071s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 203.331432s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 203.364827s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 203.398174s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 203.431543s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 203.464898s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 203.498277s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 203.531648s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 203.565008s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 203.598379s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 203.631754s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 203.665121s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 203.698489s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 203.731843s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 203.765230s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 203.798587s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 203.831955s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 203.865314s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 203.898690s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 203.932065s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 203.965425s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 203.998793s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.032169s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.065534s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 204.098897s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 204.132256s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.165643s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.199000s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 204.232370s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 204.265725s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.299103s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.332478s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 204.365837s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 204.399207s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.432567s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.465951s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 204.499312s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 204.532670s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.566036s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.599414s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 204.632785s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 204.666143s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.699509s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.732891s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 204.766253s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 204.799620s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.832980s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.866362s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 204.899722s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 204.933083s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 204.966449s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 204.999826s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.033190s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 205.066552s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 205.099920s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 205.133306s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.166665s
>             Video Output (polling):
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 205.200056s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 205.233388s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 205.266772s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.300162s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 205.333497s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 205.366859s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 205.400264s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.433608s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 205.466982s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 205.500359s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 205.533717s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.567082s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 205.600470s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 205.633800s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 205.667186s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.700572s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 205.733906s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 205.767270s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 205.800678s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.834022s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 205.867391s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 205.900772s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 205.934129s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 205.967494s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.000884s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.034215s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 206.067607s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 206.100983s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.134329s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.167684s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 206.201087s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 206.234435s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.267799s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.301192s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 206.334523s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 206.367906s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.401293s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.434627s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 206.467992s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 206.501374s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.534744s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.568099s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 206.601470s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 206.634852s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.668215s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.701605s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 206.734935s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 206.768322s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.801707s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.835041s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 206.868407s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 206.901811s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 206.935166s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 206.968509s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.001907s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 207.035265s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.068628s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.102016s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.135349s
>                 Buffer: 3 Sequence: 0 Field: Interlaced Timestamp: 207.168734s
>         test MMAP: OK
>                 fail: v4l2-test-buffers.cpp(936): buf.qbuf(q)
>                 fail: v4l2-test-buffers.cpp(976): setupUserPtr(node, q)
>         test USERPTR: FAIL
>             Video Output:
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.234735s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.268098s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.301503s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.334846s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.368202s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.401594s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.434960s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.468320s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.501709s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.535041s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.568428s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.601811s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.635146s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.668514s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.701913s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.735260s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.768617s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.802007s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.835367s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.868732s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 207.902120s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 207.935451s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 207.968837s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.002223s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.035566s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.068923s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.102327s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.135667s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.169023s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.202423s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.235785s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.269146s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.302535s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.335862s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.369252s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.402637s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.435978s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.469335s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.502705s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.536087s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.569454s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.602817s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.636177s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.669557s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.702934s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.736280s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.769648s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.803053s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.836396s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.869753s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 208.903122s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 208.936499s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 208.969870s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.003251s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.036591s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.069975s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.103363s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.136702s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.170112s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.203462s
>             Video Output (polling):
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.236804s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.270175s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.303533s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.336914s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.370269s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.403661s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.436999s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.470388s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.503774s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.537117s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.570511s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.603874s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.637222s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.670603s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.703944s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.737326s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.770694s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.804083s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.837412s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.870809s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 209.904185s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 209.937526s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 209.970900s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.004285s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.037632s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.070993s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.104382s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.137735s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.171104s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.204492s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.237822s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.271190s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.304596s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.337941s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.371310s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.404665s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.438046s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.471408s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.504794s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.538130s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.571517s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.604904s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.638234s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.671610s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.704984s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.738352s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.771725s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.805080s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.838459s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.871822s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 210.905207s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 210.938547s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 210.971931s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 211.005319s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 211.038649s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 211.072021s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 211.105420s
>                 Buffer: 0 Sequence: 0 Field: Interlaced Timestamp: 211.138776s
>                 Buffer: 1 Sequence: 0 Field: Interlaced Timestamp: 211.172136s
>                 Buffer: 2 Sequence: 0 Field: Interlaced Timestamp: 211.205492s
>         test DMABUF: OK
> 
> Total: 57, Succeeded: 56, Failed: 1, Warnings: 0
> 
> 
> 
> Lad, Prabhakar (49):
>   media: davinci: vpif_display: initialize vb2 queue and DMA context
>     during probe
>   media: davinci: vpif_display: drop buf_init() callback
>   media: davinci: vpif_display: use vb2_ops_wait_prepare/finish helper
>     functions
>   media: davinci: vpif_display: release buffers in case
>     start_streaming() call back fails
>   media: davinci: vpif_display: drop buf_cleanup() callback
>   media: davinci: vpif_display: improve vpif_buffer_prepare() callback
>   media: davinci: vpif_display: improve vpif_buffer_queue_setup()
>     function
>   media: davinci: vpif_display: improve start/stop_streaming callbacks
>   media: davinci: vpif_display: use vb2_fop_mmap/poll
>   media: davinci: vpif_display: use v4l2_fh_open and vb2_fop_release
>   media: davinci: vpif_display: use vb2_ioctl_* helpers
>   media: davinci: vpif_display: drop unused member fbuffers
>   media: davinci: vpif_display: drop reserving memory for device
>   media: davinci: vpif_display: drop unnecessary field memory
>   media: davinci: vpif_display: drop numbuffers field from common_obj
>   media: davinic: vpif_display: drop started member from struct
>     common_obj
>   media: davinci: vpif_display: initialize the video device in single
>     place
>   media: davinci: vpif_display: drop unneeded module params
>   media: davinci: vpif_display: drop cropcap
>   media: davinci: vpif_display: group v4l2_ioctl_ops
>   media: davinci: vpif_display: use SIMPLE_DEV_PM_OPS
>   media: davinci: vpif_display: return -ENODATA for *dv_timings calls
>   media: davinci: vpif_display: return -ENODATA for *std calls
>   media: davinci; vpif_display: fix checkpatch error
>   media: davinci: vpif_display: fix v4l-complinace issues
>   media: davinci: vpif_capture: initalize vb2 queue and DMA context
>     during probe
>   media: davinci: vpif_capture: drop buf_init() callback
>   media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper
>     functions
>   media: davinci: vpif_capture: release buffers in case
>     start_streaming() call back fails
>   media: davinci: vpif_capture: drop buf_cleanup() callback
>   media: davinci: vpif_capture: improve vpif_buffer_prepare() callback
>   media: davinci: vpif_capture: improve vpif_buffer_queue_setup()
>     function
>   media: davinci: vpif_capture: improve start/stop_streaming callbacks
>   media: davinci: vpif_capture: use vb2_fop_mmap/poll
>   media: davinci: vpif_capture: use v4l2_fh_open and vb2_fop_release
>   media: davinci: vpif_capture: use vb2_ioctl_* helpers
>   media: davinci: vpif_capture: drop reserving memory for device
>   media: davinci: vpif_capture: drop unnecessary field memory
>   media: davinic: vpif_capture: drop started member from struct
>     common_obj
>   media: davinci: vpif_capture: initialize the video device in single
>     place
>   media: davinci: vpif_capture: drop unneeded module params
>   media: davinci: vpif_capture: drop cropcap
>   media: davinci: vpif_capture: group v4l2_ioctl_ops
>   media: davinci: vpif_capture: use SIMPLE_DEV_PM_OPS
>   media: davinci: vpif_capture: return -ENODATA for *dv_timings calls
>   media: davinci: vpif_capture: return -ENODATA for *std calls
>   media: davinci: vpif_capture: drop check __KERNEL__
>   media: davinci: vpif_capture: fix v4l-complinace issues
>   media: davinci: vpif: add Copyright message
> 
>  drivers/media/platform/davinci/vpif_capture.c | 1420 +++++++------------------
>  drivers/media/platform/davinci/vpif_capture.h |   39 -
>  drivers/media/platform/davinci/vpif_display.c | 1196 ++++++---------------
>  drivers/media/platform/davinci/vpif_display.h |   44 +-
>  4 files changed, 746 insertions(+), 1953 deletions(-)
> 

