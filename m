Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbaDILUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:20:01 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:52598 "EHLO
	devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110AbaDILT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:19:58 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 0/24] Introduce ff-memless-next as an improved replacement for ff-memless
Date: Wed, 09 Apr 2014 13:10:41 +0200
Message-ID: <1609685.QRL9N9sQvX@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ff-memless-next (MLNX) is a largely improved version of the current ff-memless
(FFML) driver. MLNX supports all force feedback effects currently available in
the Linux force feedback userspace API. All effects are handled in accordance
with Microsoft's DirectInput/XInput. Most notable changes include support for
conditional effects, proper handling of all periodic waveforms and improved
emulation of rumble effects through periodic effects. MLNX also uses its own
kernel API to pass processed effects to hardware-specific drivers instead of
abusing "ff_effect" struct. The API is documented in the respective header
file.

MLNX has been expanded to be a direct replacement for FFML.

Support for FF_PERIODIC and FF_RAMP has been added to all devices that
support FF_CONSTANT as a part of the port to the new API.

This patch series:
1) Adds "ff-memless-next" module [1]
2) Ports all hardware-specific drivers to MLNX's API [2-23]
3) Removes FFML and replaces it with MLNX [24]

Michal Malý
