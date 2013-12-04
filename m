Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab3LDRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:33:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab3LDRdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:33:09 -0500
Date: Wed, 4 Dec 2013 12:32:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131204173238.GD19087@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131204015657.GD3298@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204015657.GD3298@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:56:57AM +0800, Baoquan He wrote:
> On 11/20/13 at 12:50pm, Vivek Goyal wrote:
> > + * that kexec_mutex is held.
> > + */
> 
> I think kexec_add_buffer is guaranteed to be called before allocating
> control pages, why not updating image->control_page after each time
> kexec_add_buffer is called. Then when control page is needed, effective
> address in crash_kernel region can be given. This can be a little more
> efficient.

image->control_page controls the lowest address available for control
pages in crash kernel region. When we do kexec_add_buffer, we don't
necessarily know whether there is an empty page available between
segments or not.

Also, existing logic for kexec does not update the image->control_page
when segments are being copied.

So I think this does not offer any huge benefits and it is not performance
critical path. I will just leave it as it is.

Thanks
Vivek
