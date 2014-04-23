Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaDWKsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:48:05 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:43931 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaDWKsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140423084057.GY10722@phenom.ffwll.local>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
	<1398179373-29966-5-git-send-email-thierry.reding@gmail.com>
	<20140422154807.GT10722@phenom.ffwll.local>
	<20140423071714.GB31226@ulmo>
	<20140423084057.GY10722@phenom.ffwll.local>
Date: Wed, 23 Apr 2014 12:48:00 +0200
Message-ID: <CANq1E4R3S4HdV8OcKw4jk2iLiMJgCPe1m=iNxaA_KfnaM0RFyQ@mail.gmail.com>
Subject: Re: [RFC 4/5] drm: Introduce drm_set_unique()
From: David Herrmann <dh.herrmann@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-tegra@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Apr 23, 2014 at 10:40 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Apr 23, 2014 at 09:17:16AM +0200, Thierry Reding wrote:
>> On second thought, wouldn't this be better located in drm_stub.c? It
>> isn't really related to the IOCTL code except that one of the IOCTLs now
>> uses the information set by this function. Logically I think it belongs
>> with the likes of drm_dev_alloc() and drm_dev_register().
>
> Yeah makes sense. Tbh the entire split-up of these core drm functions is
> still a bit messy, so I don't mind if it's a bit inconsistent really. We
> can do the suffling when someone bothers with the kerneldoc for all of
> them and pulls it into the drm docbook.

During drm_dev_*() cleanup, I tried to keep the following structure:
  drm_drv.c: global drm-module setup
  drm_stub.c: drm_device allocation, registration and lifetime management
  drm_fops.c: reference-implementation of the drm file_operations

The only thing that's wrongly placed is ioctl handling (which somehow
ended up in drm_drv.c instead of drm_fops.c). drm_stub.c is where all
the generic and mandatory DRM device handling is placed so yeah, I'd
put the set_unique() there.

Thanks
David
