Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaHAMut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:50:49 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:43973 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbaHAMus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:50:48 -0400
Date: Fri, 1 Aug 2014 08:50:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Jianyu Zhan <Jianyu.Zhan@emc.com>
Subject: Re: [PATCH RFC] sysfs: fix the race of "parent deleted before child
 added"
Message-ID: <20140801125045.GA21624@htj.dyndns.org>
References: <1406891892-10992-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406891892-10992-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 01, 2014 at 07:18:12PM +0800, Jianyu Zhan wrote:
> A proper fix for this is to pin the parent kernfs_node on the
> dir_entry creation point (sysfs_create_dir_ns), and to de-pin the parent
> on the dir_entry deletion point(sysfs_remove_dir).

The *only* reason we have the warning at all is because the driver
model wants to enforce that destruction is performed in the proper
order and what you're doing is just circumventing the detection logic.
We might as well just remove it.  Please track down why the specific
warning that you saw happened.  We wanna learn about them and fix
them.

Thanks.

-- 
tejun
