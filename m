Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaFPDuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 23:50:12 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:32904 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaFPDuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 23:50:07 -0400
Message-ID: <539E6963.6010509@landley.net>
Date: Sun, 15 Jun 2014 22:49:55 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Roman Pen <r.peniaev@gmail.com>
CC: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] init: fix race between rootfs mount and firmware
 loading
References: <1402830413-4009-1-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1402830413-4009-1-git-send-email-r.peniaev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/14 06:06, Roman Pen wrote:
> The thing is that built-in modules are being inited before
> rootfs mount. Some of the modules can request firmware loading
> using async 'request_firmware_nowait' call just while inition,
> so we can catch this kind of race: rootfs does not exist yet,
> but we are going to open and load firmware file requesting from
> the kernel.

Fixing this was on my todo list for initmpfs, along with a kernel
command line parameter to pass in size= (other than the default 50%),
and fixing the stupid "don't show initramfs in /proc/self/mountinfo
becuase rootfs is _magic_ and it's not like anything else ever gets
overmounted because nobody would _ever_ do that, no we need a magic
special case for this one thing..."

Concept seems sound, quick glance at the patch looks ok to me, my only
"can't say whether or not this is ok off the top of my head" is whether
the wakeup's being done from the right place.

Rob
