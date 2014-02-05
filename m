Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaBERfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:35:33 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35636 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaBERfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:35:32 -0500
MIME-Version: 1.0
Date: Wed, 5 Feb 2014 11:35:31 -0600
Message-ID: <CAFZT-jKRnH_2RQVhcY5wkJf_P1T+uMOueGst6-MypEC27FJZEQ@mail.gmail.com>
Subject: mutex_unlock is missed in function (drm_crtc_init) in file (linux-3.13/drivers/gpu/drm/drm_crtc.c)
From: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug Report Filed: https://bugzilla.kernel.org/show_bug.cgi?id=70081
Linux Version [3.13]
Configuration: Default configuration for x86

In function (drm_crtc_init) in file (linux-3.13/drivers/gpu/drm/drm_crtc.c):

The structure (crtc->mutex) gets successfully locked at line (636) by
(drm_modeset_lock_all(dev)), but it is not unlocked before line (637)
where the structure is reinitialized. After line (637) the
re-initialized structure gets locked at (638) and unlocked at line
(650) by (drm_modeset_unlock_all(dev)).

A possible solution is to call (drm_modeset_unlock_all(dev)) before
the re-initialization line (637).


Thanks,
Ahmed
