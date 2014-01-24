Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaAXMR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:17:56 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:49756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaAXMRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:17:55 -0500
Message-ID: <1390565870.4257.40.camel@jlt4.sipsolutions.net>
Subject: Re: [mac80211] BUG: unable to handle kernel paging request at
 6b6b6b8f
From: Johannes Berg <johannes@sipsolutions.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Jan 2014 13:17:50 +0100
In-Reply-To: <20140124120840.GA25638@localhost> (sfid-20140124_131240_755302_221A9D31)
References: <20140124120840.GA25638@localhost>
	 (sfid-20140124_131240_755302_221A9D31)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 20:08 +0800, Fengguang Wu wrote:
> Hi Johannes,
> 
> The BUG does not show up in linux-next 20140124, is it fixed now?

It isn't in linux-next yet I believe (mac80211-next isn't in there), but
yeah, I fixed it already, ran into it myself yesterday. Hope it didn't
cause you too much trouble. The problem was that I misplaced some code
because I didn't notice that the if () condition (see below) had no
braces.

I replaced that commit with
commit 091a69f86862454c282d4a64c9d66074e60514ea
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Jan 22 10:36:59 2014 +0100

    mac80211: remove module handling from rate control ops

which now contains this change

        list_for_each_entry(alg, &rate_ctrl_algs, list) {
-               if (!strcmp(alg->ops->name, name))
-                       if (try_module_get(alg->ops->module)) {
-                               ops = alg->ops;
-                               break;
-                       }
+               if (!strcmp(alg->ops->name, name)) {
+                       ops = alg->ops;
+                       break;
+               }
        }

(note the new set of braces added around the content of the strcmp if)

Sorry!

johannes


