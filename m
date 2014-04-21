Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaDUV02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:26:28 -0400
Received: from mail001.aei.ca ([206.123.6.130]:34985 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434AbaDUV0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:26:24 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [git pull] drm fixes
Date: Mon, 21 Apr 2014 17:26:15 -0400
Message-ID: <1549585.kmUPduLgev@grover>
Organization: me
User-Agent: KMail/4.13 (Linux/3.15.0-1-git; KDE/4.13.0; x86_64; ; )
In-Reply-To: <2619529.mEMJol0YfM@grover>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie> <3853215.bjCM91curD@grover> <2619529.mEMJol0YfM@grover>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2014 15:08:24 Ed Tomlinson wrote:
> On Monday 21 April 2014 10:25:25 Ed Tomlinson wrote:
> > On Saturday 19 April 2014 21:03:05 Markus Trippelsdorf wrote:
> > > On 2014.04.19 at 08:19 +0100, Dave Airlie wrote:
> > > > 
> > > > Unfortunately this contains no easter eggs, its a bit larger than I'd 
> > > > like, but I included a patch that just moves code from one file to another 
> > > > and I'd like to avoid merge conflicts with that later, so it makes it seem 
> > > > worse than it is,
> > > 
> > > > Christian König (2):
> > > >       drm/radeon: apply more strict limits for PLL params v2
> > > >       drm/radeon: improve PLL params if we don't match exactly v2
> > > 
> > > commit f8a2645ecede4eaf90b3d785f2805c8ecb76d43e
> > > Author: Christian König <christian.koenig@amd.com>
> > > Date:   Wed Apr 16 11:54:21 2014 +0200
> > > 
> > >     drm/radeon: improve PLL params if we don't match exactly v2
> > > 
> > > The commit above causes my monitor to just stay blank after boot.
> > > No framebuffer, no Xorg, no nothing. I'm using a Radeon RS780.

Reverting 

commit 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Apr 7 10:33:46 2014 -0400

    drm/radeon/dp: switch to the common i2c over aux code
    
    Provides a nice cleanup in radeon.
    
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
    Signed-off-by: Christian König <christian.koenig@amd.com>

Restores the display - no more i2c errors

I have dmesgs of all three tests if anyone wants them.

Thanks
Ed Tomlinson


> > I have the same symptoms with rc2 and a r7 260x using display port.  I cannot 
> > seem to get a dmesg of a failure (I _really_ need to figure out how to add
> > a serial console).  I'll try reverting once I figure out how to get pacman to
> > do a revert when building from git.
> 
> Neither reverting the above patch or add the fix from "https://bugs.freedesktop.org/show_bug.cgi?id=77673"
> helps here.  I managed to get dmesg(s) from 14.1 and 15-rc2.  The major difference has to do with i2c.  On the
> 14.1 kernel I see:
> 
> [    2.679029] [drm] ib test on ring 5 succeeded
> [    2.699317] [drm:radeon_dp_i2c_aux_ch], aux_i2c nack
> [    2.699478] [drm:radeon_dp_i2c_aux_ch], aux_i2c nack
> [    2.699535] [drm] Radeon Display Connectors
> [    2.699536] [drm] Connector 0:
> [    2.699537] [drm]   DP-1
> [    2.699537] [drm]   HPD2
> [    2.699538] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
> [    2.699538] [drm]   Encoders:
> [    2.699539] [drm]     DFP1: INTERNAL_UNIPHY2
> 
> skipping the rest of the connectors
> [    2.699647] [drm:radeon_atom_encoder_dpms], encoder dpms 33 to mode 3, devices 00000008, acti
> ve_devices 00000000
> [    2.699648] [drm:radeon_atom_encoder_dpms], encoder dpms 33 to mode 3, devices 00000080, acti
> ve_devices 00000000
> [    2.699649] [drm:radeon_atom_encoder_dpms], encoder dpms 32 to mode 3, devices 00000200, acti
> ve_devices 00000000
> [    2.699650] [drm:radeon_atom_encoder_dpms], encoder dpms 30 to mode 3, devices 00000400, acti
> ve_devices 00000000
> [    2.699651] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, acti
> ve_devices 00000000
> [    2.706746] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [    2.712729] [drm:radeon_dp_getdpcd], DPCD: 
> [    2.712731] [drm:radeon_dp_getdpcd], 11 
> [    2.712732] [drm:radeon_dp_getdpcd], 0a 
> [    2.712733] [drm:radeon_dp_getdpcd], 84 
> [    2.712733] [drm:radeon_dp_getdpcd], 00 
> [    2.712734] [drm:radeon_dp_getdpcd], 01 
> [    2.712735] [drm:radeon_dp_getdpcd], 00 
> [    2.712735] [drm:radeon_dp_getdpcd], 00 
> [    2.712736] [drm:radeon_dp_getdpcd], 00 
> [    2.712736] [drm:radeon_dp_getdpcd], 00 
> [    2.712737] [drm:radeon_dp_getdpcd], 00 
> [    2.712738] [drm:radeon_dp_getdpcd], 00 
> [    2.712739] [drm:radeon_dp_getdpcd], 00 
> [    2.712739] [drm:radeon_dp_getdpcd], 00 
> [    2.712740] [drm:radeon_dp_getdpcd], 00 
> [    2.712741] [drm:radeon_dp_getdpcd], 00 
> [    2.712741] [drm:radeon_dp_getdpcd], 
> [    2.712746] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
> [    2.713618] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [    2.738573] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [    2.770849] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [    2.770907] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] probed modes :
> [    2.770908] [drm:drm_mode_debug_printmodeline], Modeline 28:"1920x1200" 60 154000 1920 1968 2
> 000 2080 1200 1203 1209 1235 0x48 0x9
> 
> And on the 15-rc2 kernel 
> 
> [    2.580468] [drm] ib test on ring 4 succeeded in 0 usecs
> [    2.601369] [drm] ib test on ring 5 succeeded
> [    2.622309] [drm] ib test on ring 6 succeeded
> [    2.623058] [drm] ib test on ring 7 succeeded
> [    2.623449] [drm] Radeon Display Connectors
> [    2.623452] [drm] Connector 0:
> [    2.623453] [drm]   DP-1
> [    2.623455] [drm]   HPD2
> [    2.623457] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
> [    2.623459] [drm]   Encoders:
> [    2.623461] [drm]     DFP1: INTERNAL_UNIPHY2
> 
> (connectors skipped)
> 
> [    2.623618] [drm:radeon_atom_encoder_dpms] encoder dpms 33 to mode 3, devices 00000080, activ
> e_devices 00000000
> [    2.623620] [drm:radeon_atom_encoder_dpms] encoder dpms 32 to mode 3, devices 00000200, activ
> e_devices 00000000
> [    2.623621] [drm:radeon_atom_encoder_dpms] encoder dpms 30 to mode 3, devices 00000400, activ
> e_devices 00000000
> [    2.623623] [drm:radeon_atom_encoder_dpms] encoder dpms 21 to mode 3, devices 00000001, activ
> e_devices 00000000
> [    2.630704] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:26:DP-1]
> [    2.636897] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.636917] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.636936] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.636955] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.636973] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.636994] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637015] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637016] [drm:drm_dp_dpcd_access] too many retries, giving up
> [    2.637019] [drm:radeon_atombios_connected_scratch_regs] DFP1 connected
> [    2.637042] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637063] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637083] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637103] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637124] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637144] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637164] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637165] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.637186] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637206] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637226] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637247] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637267] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637288] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637309] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637309] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.637330] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637350] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637371] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637391] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637411] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637431] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637452] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637453] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.637473] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637493] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637514] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637534] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637555] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637575] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637595] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637596] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.637616] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637636] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637656] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637676] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637697] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637718] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637738] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637738] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.637757] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero[    2.637757] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637776] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637795] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637813] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637832] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637851] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637870] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637870] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.637892] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637912] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637932] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637953] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637973] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.637994] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638014] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638015] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.638036] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638056] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638077] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638097] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638117] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638137] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638158] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638159] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.638179] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638200] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638220] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638241] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638261] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638281] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638301] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638302] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.638322] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638342] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638363] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638383] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638403] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638423] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638444] [drm:radeon_process_aux_ch] dp_aux_ch flags not zero
> [    2.638444] [drm:drm_dp_i2c_do_msg] too many retries, giving up
> [    2.638452] [drm:drm_helper_probe_single_connector_modes] [CONNECTOR:26:DP-1] probed modes :
> [    2.638455] [drm:drm_mode_debug_printmodeline] Modeline 38:"1024x768" 60 65000 1024 1048 1184
>  1344 768 771 777 806 0x40 0xa
> 
> Anyone want the full dmesgs?
> 
> Suggestions?
> 
> Ed Tomlinson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

