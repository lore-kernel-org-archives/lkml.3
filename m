Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3BCJme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 04:42:34 -0500
Received: from kepler.killerwolves.net ([103.4.235.74]:44504 "EHLO
	kepler.killerwolves.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3BCJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 04:42:31 -0500
X-Spam-Check-By: kepler
Message-ID: <510E3101.7070108@killerwolves.net>
Date: Sun, 03 Feb 2013 19:42:25 +1000
From: Ben Peddell <klightspeed@killerwolves.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] target: OOPS in target_fabric_port_link on v3.7.4
 and v3.4.27
References: <510E207F.1@killerwolves.net>
In-Reply-To: <510E207F.1@killerwolves.net>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/02/2013 6:31 PM, Ben Peddell wrote:
> There is an OOPS in target_fabric_port_link due to a use before
> initialization error.
> 
> commit 0ff8754981261a80f4b77db2536dfea92c2d4539 (target: Add link_magic
> for fabric allow_link destination target_items) as merged in the
> linux-3.7.y and linux-3.4.y branches relies on one of the changes that
> occurred in commit 0fd97ccf45be26fb01b3a412f1f6c6b5044b2f16 (Simplify
> the code a lot by killing the superflous struct se_subsystem_dev).
> Without that change, dev is dereferenced before it is initialized.
> 
> Commit 0fd97ccf45be26fb01b3a412f1f6c6b5044b2f16 looks too invasive,
> which I would guess would be why it wasn't merged in.
> 
> One option would be to move the dev->dev_link_magic test to after dev is
> initialized, as presented the patches I will be following up with.
> 
> An alternative that will resolve this OOPS is to revert commit
> fdf9d862969f1be18814273b03fb9497ec2dbdae (target: Add link_magic for
> fabric allow_link destination target_items) on branch linux-3.7.y, and
> revert commit 92a7389317838f3338466df0c0e3d23ad33cb1f4 (target: Add
> link_magic for fabric allow_link destination target_items) on branch
> linux-3.4.y

I should have looked in the stable queue first - an equivalent to my
patch is already in the stable queue for 3.4 and 3.7

