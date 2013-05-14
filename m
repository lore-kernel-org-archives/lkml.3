Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3ENIyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3ENIyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:54:49 -0400
Subject: Re: linux-next: Tree for May 8 (dlm)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Teigland <teigland@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <519142E7.4080009@infradead.org>
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
	 <518A93BD.3020300@infradead.org>
	 <20130509094745.049e46fff25f357e7eb50123@canb.auug.org.au>
	 <20130509165028.GA18077@redhat.com>  <518BD826.4040403@infradead.org>
	 <1368436712.2882.14.camel@menhir> <5191153F.8000001@infradead.org>
	 <51913F8B.7080201@infradead.org> <51914045.1060900@infradead.org>
	 <519142E7.4080009@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 14 May 2013 09:51:59 +0100
Message-ID: <1368521520.2711.1.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2013-05-13 at 12:45 -0700, Randy Dunlap wrote:
> [resending since mail server dropped it]
> 
> On 05/13/13 12:34, Randy Dunlap wrote:
> > On 05/13/13 12:31, Randy Dunlap wrote:
> >> On 05/13/13 09:30, Randy Dunlap wrote:
> >>> On 05/13/13 02:18, Steven Whitehouse wrote:
> >>>> Hi,
> >>>>
> >>>> On Thu, 2013-05-09 at 10:08 -0700, Randy Dunlap wrote:
> >>>>> On 05/09/13 09:50, David Teigland wrote:
> >>>>>> On Thu, May 09, 2013 at 09:47:45AM +1000, Stephen Rothwell wrote:
> >>>>>>> [Just forwarding to David ...]
> >>>>>>>
> >>>>>>> On Wed, 08 May 2013 11:04:45 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> >>>>>>>>
> >>>>>>>> on x86_64:
> >>>>>>>>
> >>>>>>>> when CONFIG_GFS2_FS_LOCKING_DLM=y and CONFIG_DLM=m:
> >>>>>>>>
> >>>>>>>> fs/built-in.o: In function `gfs2_lock':
> >>>>>>>> file.c:(.text+0xa512c): undefined reference to `dlm_posix_get'
> >>>>>>>> file.c:(.text+0xa5140): undefined reference to `dlm_posix_unlock'
> >>>>>>>> file.c:(.text+0xa514a): undefined reference to `dlm_posix_lock'
> >>>>>>
> >>>>>> gfs2/file.c calls the dlm directly, so I suppose gfs2 itself needs
> >>>>>> to depend on the dlm.  It's been like this for a long time, so I
> >>>>>> don't know why it only appeared now.
> >>>>>
> >>>>> Agreed to both statements.
> >>>>>
> >>>>>>>> fs/built-in.o: In function `gdlm_cancel':
> >>>>>>>> lock_dlm.c:(.text+0xb3f57): undefined reference to `dlm_unlock'
> >>>>>>>> fs/built-in.o: In function `gdlm_unmount':
> >>>>>>>> lock_dlm.c:(.text+0xb40ff): undefined reference to `dlm_release_lockspace'
> >>>>>>>> fs/built-in.o: In function `sync_unlock.isra.4':
> >>>>>>>> lock_dlm.c:(.text+0xb420d): undefined reference to `dlm_unlock'
> >>>>>>>> fs/built-in.o: In function `sync_lock.isra.5':
> >>>>>>>> lock_dlm.c:(.text+0xb42d9): undefined reference to `dlm_lock'
> >>>>>>>> fs/built-in.o: In function `gdlm_put_lock':
> >>>>>>>> lock_dlm.c:(.text+0xb45e7): undefined reference to `dlm_unlock'
> >>>>>>>> fs/built-in.o: In function `gdlm_mount':
> >>>>>>>> lock_dlm.c:(.text+0xb4928): undefined reference to `dlm_new_lockspace'
> >>>>>>>> lock_dlm.c:(.text+0xb4c75): undefined reference to `dlm_release_lockspace'
> >>>>>>>> fs/built-in.o: In function `gdlm_lock':
> >>>>>>>> lock_dlm.c:(.text+0xb529f): undefined reference to `dlm_lock'
> >>>>>>
> >>>>>> lock_dlm.c is GFS2_FS_LOCKING_DLM which depends on DLM.
> >>>>>> Is that not correct?
> >>>>>
> >>>>> The problem is that GFS2_FS_LOCKING_DLM is a bool.  It depends on DLM,
> >>>>> which is a tristate with a value of 'm', so the bool is true (as long
> >>>>> as DLM != 'n').
> >>>>>
> >>>>> One option is to make GFS2_FS_LOCKING_DLM depend on "DLM != n", but a
> >>>>> better fix is to make GFS2_FS depend on DLM, like you said above.
> >>>>>
> >>>>>
> >>>>
> >>>> Does this look correct? As Dave says this has not changed for some time.
> >>>> It seems that every time we try to get this right, there is always some
> >>>> corner case that is missed :( 
> >>>
> >>> Sorry, I misspoke above.   It will have to depend on DLM=y since DLM=m
> >>> is what is causing these build errors.
> >>
> >> and that is too strict.  It needs to allow for both dlm and gfs2 built as
> >> loadable modules.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> >>>> We can't make GFS2_FS depend on DLM as otherwise there would be no
> >>>> reason to have GFS2_FS_LOCKING_DLM, at least if I've understood the
> >>>> issue here correctly. So I've come up with the following... does it look
> >>>> ok?
> >>>>
> >>>>
> >>>> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> >>>> index eb08c9e..edbad96 100644
> >>>> --- a/fs/gfs2/Kconfig
> >>>> +++ b/fs/gfs2/Kconfig
> >>>> @@ -26,7 +26,7 @@ config GFS2_FS
> >>>>  config GFS2_FS_LOCKING_DLM
> >>>>  	bool "GFS2 DLM locking"
> >>>>  	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
> >>>> -		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
> >>>> +		HOTPLUG && (DLM!=n) && CONFIGFS_FS && SYSFS
> >>>
> >>> 		HOTPLUG && DLM=y && CONFIGFS_FS && SYSFS
> >>
> >> 		HOTPLUG && CONFIGFS_FS && SYSFS && (DLM=y || DLM=GFS2_FS)
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> >> I think.
> > 
> > tested and works AFAICT.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
Yes, that looks better to me. Can you send that as a patch? Then I can
stick it in the tree for further testing. Thanks,

Steve.


