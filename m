Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaBFTN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:13:27 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:42637
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756854AbaBFTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:13:24 -0500
Date: Thu, 6 Feb 2014 13:13:20 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vladimir Davydov <vdavydov@parallels.com>
cc: penberg@kernel.org, akpm@linux-foundation.org, rientjes@google.com,
        mhocko@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        devel@openvz.org
Subject: Re: [PATCH RFC] slub: do not drop slab_mutex for
 sysfs_slab_{add,remove}
In-Reply-To: <52F3CF12.70905@parallels.com>
Message-ID: <alpine.DEB.2.10.1402061312180.6137@nuc>
References: <1391702294-27289-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.10.1402061021180.4927@nuc> <52F3CF12.70905@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Vladimir Davydov wrote:

> Hmm... IIUC the only function of concern is kobject_uevent() -
> everything else called from sysfs_slab_{add,remove} is a mix of kmalloc,
> kfree, mutex_lock/unlock - in short, nothing dangerous. There we do
> call_usermodehelper(), but we do it with UMH_WAIT_EXEC, which means
> "wait for exec only, but not for the process to complete". An exec
> shouldn't issue any slab-related stuff AFAIU. At least, I tried to run
> the patched kernel with lockdep enabled and got no warnings at all when
> getting uevents about adding/removing caches. That's why I started to
> doubt whether we really need this lock...
>
> Please correct me if I'm wrong.

I have had this deadlock a couple of years ago. Sysfs seems to change over
time. Not sure if that is still the case.

> > I would be very thankful, if you can get that actually working reliably
> > without deadlock issues.
>
> If there is no choice rather than moving sysfs_slab_{add,remove} out of
> the slab_mutex critical section, I'll have to do it that way. But first
> I'd like to make sure it cannot be done with less footprint.

I am all for holding the lock as long as possible.

