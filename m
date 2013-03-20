Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3CTRQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:16:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37843 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab3CTRQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:16:32 -0400
X-Sasl-enc: 1UQScLlxBzf5mI+33YLsk5gGbWpFdEje4W68VEGH50y8 1363799791
Date: Wed, 20 Mar 2013 10:17:56 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Hillf Danton <dhillf@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
Message-ID: <20130320171756.GA28605@kroah.com>
References: <5144BB15.3020002@gmail.com>
 <CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com>
 <5145D236.70203@gmail.com>
 <CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com>
 <5147C821.6070703@gmail.com>
 <CACVXFVNMtY5tvAvyqyAyYRwBzfTtZKkDambDUTUNYwd0Q3XkXA@mail.gmail.com>
 <CACVXFVPV3mq=k-AZ1bYkAMdxwXD96Ty7DYeh9H9J=yvA4m=rGA@mail.gmail.com>
 <51489242.9020801@gmail.com>
 <CACVXFVN8EDMgHyshxX41er463rMsbUSrzs9pX17NdDg4PVHSvw@mail.gmail.com>
 <5149C900.6020709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5149C900.6020709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 10:34:40AM -0400, Sasha Levin wrote:
> On 03/19/2013 09:02 PM, Ming Lei wrote:
> > Hi Sasha,
> > 
> > On Wed, Mar 20, 2013 at 12:28 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> >> On 03/19/2013 07:54 AM, Ming Lei wrote:
> >>
> >> With v3 of the patch:
> >>
> >> [ 1275.665758] sysfs_dir_pos-973 sysfs_dirent use after free: tun(tun)-uevent, 2-1472641949
> > 
> > Thanks again for your test.
> > 
> > Looks it is caused by another bug in sysfs_readdir:  if filldir() returns
> > failure(such as small buffer length passed from userspace, very probably
> > for trinity) in case of 'if (filp->f_pos ==  0 or 1)',
> > filp->private_data still will
> > point to one refcount-balanced sysfs_dirent object.
> > 
> > V4 adds fix for this situation, please test attachment v4 patch.
> 
> With this one it didn't happen at all during overnight tests so looks like it did
> the job.

Thanks for testing, and thanks Ming, for finding and fixing this.

greg k-h
