Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031367Ab3HIW05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:26:57 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48953 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031329Ab3HIW04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:26:56 -0400
MIME-Version: 1.0
Date: Fri, 9 Aug 2013 15:26:55 -0700
X-Google-Sender-Auth: 6k8g-dvqinh_PILWcxqKF118fek
Message-ID: <CAGXu5jLSmJ6NSdi2krWpXbGJ+oE7hTa80ff=JHA4AsYo9=sX5A@mail.gmail.com>
Subject: i915: build warning in i915_hangcheck_elapsed
From: Kees Cook <keescook@chromium.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9107e9d227e3b0893829baee4ac59feb874d4c23 introduced "score", and while
it's actually not possible for it to be uninitialized (given the
return values of ring_stuck()), the warning should be suppressed. It
probably just needs a "default:" added to the switch statement.

drivers/gpu/drm/i915/i915_irq.c:1943:27: warning: ‘score’ may be used
uninitialized in this function [-Wuninitialized]

-Kees

-- 
Kees Cook
Chrome OS Security
