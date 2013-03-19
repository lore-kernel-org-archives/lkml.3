Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab3CSVXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:23:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934103Ab3CSVW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:22:59 -0400
Date: Tue, 19 Mar 2013 17:22:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 08/21] vmcore: copy non page-size aligned head and
 tail pages in 2nd kernel
Message-ID: <20130319212244.GE3872@redhat.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
 <20130316040132.15064.42257.stgit@localhost6.localdomain6>
 <878v5jqf5e.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v5jqf5e.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 01:59:57PM -0700, Eric W. Biederman wrote:
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
> > Due to mmap() requirement, we need to copy pages not starting or
> > ending with page-size aligned address in 2nd kernel and to map them to
> > user-space.
> >
> > For example, see the map below:
> >
> >     00000000-00010000 : reserved
> >     00010000-0009f800 : System RAM
> >     0009f800-000a0000 : reserved
> >
> > where the System RAM ends with 0x9f800 that is not page-size
> > aligned. This map is divided into two parts:
> >
> >     00010000-0009f000
> >     0009f000-0009f800
> >
> > and the first one is kept in old memory and the 2nd one is copied into
> > buffer on 2nd kernel.
> >
> > This kind of non-page-size-aligned area can always occur since any
> > part of System RAM can be converted into reserved area at runtime.
> >
> > If not doing copying like this and if remapping non page-size aligned
> > pages on old memory directly, mmap() had to export memory which is not
> > dump target to user-space. In the above example this is reserved
> > 0x9f800-0xa0000.
> 
> So I have a question.  Would it not be easier to only support mmaping on
> the things that are easily mmapable?  And in the oddball corner cases
> require reading the data instead.

Hi Eric, 

Are you saying that some parts of the vmcore file will support mmap() and
others will not. If yes, how would a user know which parts of file are
mappable and which are not.

Thanks
Vivek
