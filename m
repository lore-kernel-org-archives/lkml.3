Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3KFDdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:33:16 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:57449 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3KFDdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:33:15 -0500
MIME-Version: 1.0
In-Reply-To: <1381506450.7844.4.camel@chenjun-workstation>
References: <1381506450.7844.4.camel@chenjun-workstation>
Date: Wed, 6 Nov 2013 13:33:13 +1000
Message-ID: <CAPM=9tw4MbFDDKyuEZS2i2sh07cGgzM6GdeK_UkEiuXW9v7U-A@mail.gmail.com>
Subject: Re: [PATCH] drm: Add the mutex protection in drm_do_vm_fault.
From: Dave Airlie <airlied@gmail.com>
To: Jun Chen <jun.d.chen@intel.com>
Cc: Dave Airlie <airlied@linux.ie>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 1:47 AM, Jun Chen <jun.d.chen@intel.com> wrote:
>
> There are no mutex protection for the dev->map_hash while calling
> the drm_ht_find_item in the function drm_do_vm_fault. So try to
> mutex firstly and then find the list for using to avoid this race
> condition.

Can I ask how or why you found this? from what I can see we really
shouldn't be executing this code on modern drivers.

this is the sort of thing I'd really like to have tested on real hw,
which means someone booting it on AGP using UMS drivers I think.

Dave.
