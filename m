Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858Ab3BSXFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:05:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab3BSXFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:05:54 -0500
Date: Tue, 19 Feb 2013 18:05:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] vmcore: copy ELF note segments in buffer on 2nd
 kernel
Message-ID: <20130219230542.GF6039@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101232.22466.44026.stgit@localhost6.localdomain6>
 <20130215165327.GH27784@redhat.com>
 <20130219.020234.255275278.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219.020234.255275278.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 02:02:34AM +0900, HATAYAMA Daisuke wrote:

[..]
> Anyway, what I'll do in the next version, are in summary:
> 
> - append pad notes in each notes on the 1st kernel in every
>   architectures, and
> - check if each note is in page-size boundary, and if not so, copy it
>   in the 2nd kernel and then append pad notes to it.

Makes sense to me. Most of the time first kernel and second kernel are
same so no copying of notes will take place. Only in corner cases of
older kernel being used as first kernel, copying will take place.

One other possibility is that deny mmap() if first kernel did not
prepare notes on page size boundary.

Thanks
Vivek
