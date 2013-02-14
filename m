Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3BNE1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:27:20 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36785 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3BNE1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:27:19 -0500
Date: Wed, 13 Feb 2013 20:27:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chung-Yih Wang <cywang@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - fix 1->3 contact transition reporting
Message-ID: <20130214042715.GD2472@core.coreip.homeip.net>
References: <1359707340-13033-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359707340-13033-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 04:29:00PM +0800, Daniel Kurtz wrote:
> Investigating the following gesture highlighted two slight implementation
> errors with choosing which slots to report in which slot when multiple
> contacts are present:
> 
> Action                 SGM  AGM (MTB slot:Contact)
> 1. Touch contact 0    (0:0)
> 2. Touch contact 1    (0:0, 1:1)
> 3. Lift  contact 0    (1:1)
> 4. Touch contacts 2,3 (0:2, 1:3)
> 
> In step 4, slot 1 was not being cleared first, which means the same
> tracking ID was being used for reporting both the old contact 1 and the
> new contact 3.  This could result in "drumroll", where the old contact 1
> would appear to suddenly jump to new finger 3 position.
> 
> Similarly, if contacts 2 & 3 are not detected at the same sample, step 4
> is split into two:
> 
> Action                SGM  AGM  (MTB slot:contact)
> 1. Touch contact 0   (0:0)
> 2. Touch contact 1   (0:0, 1:1)
> 3. Lift  contact 0   (1:1)
> 4. Touch contact 2   (0:2, 1:1)
> 5. Touch contact 3   (0:2, 1:3)
> 
> In this case, there was also a bug.  In step 4, when contact 1 moves from
> SGM to AGM and contact 2 is first reported in SGM, slot 0 was actually
> empty.  So slot 0 can be used to report the new SGM (contact 0),
> immediately.  Since it was empty, contact 2 in slot 0 will get a new
> tracking ID.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Applied, thank you Daniel.

-- 
Dmitry
