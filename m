Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3CTOef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:34:35 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46603 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3CTOee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:34:34 -0400
Message-ID: <5149C900.6020709@gmail.com>
Date: Wed, 20 Mar 2013 10:34:40 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com> <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com> <51448AC9.7080105@gmail.com> <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com> <CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com> <5144BB15.3020002@gmail.com> <CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com> <5145D236.70203@gmail.com> <CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com> <5147C821.6070703@gmail.com> <CACVXFVNMtY5tvAvyqyAyYRwBzfTtZKkDambDUTUNYwd0Q3XkXA@mail.gmail.com> <CACVXFVPV3mq=k-AZ1bYkAMdxwXD96Ty7DYeh9H9J=yvA4m=rGA@mail.gmail.com> <51489242.9020801@gmail.com> <CACVXFVN8EDMgHyshxX41er463rMsbUSrzs9pX17NdDg4PVHSvw@mail.gmail.com>
In-Reply-To: <CACVXFVN8EDMgHyshxX41er463rMsbUSrzs9pX17NdDg4PVHSvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 09:02 PM, Ming Lei wrote:
> Hi Sasha,
> 
> On Wed, Mar 20, 2013 at 12:28 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> On 03/19/2013 07:54 AM, Ming Lei wrote:
>>
>> With v3 of the patch:
>>
>> [ 1275.665758] sysfs_dir_pos-973 sysfs_dirent use after free: tun(tun)-uevent, 2-1472641949
> 
> Thanks again for your test.
> 
> Looks it is caused by another bug in sysfs_readdir:  if filldir() returns
> failure(such as small buffer length passed from userspace, very probably
> for trinity) in case of 'if (filp->f_pos ==  0 or 1)',
> filp->private_data still will
> point to one refcount-balanced sysfs_dirent object.
> 
> V4 adds fix for this situation, please test attachment v4 patch.

With this one it didn't happen at all during overnight tests so looks like it did
the job.

Thanks!

