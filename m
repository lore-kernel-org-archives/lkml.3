Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaCQQRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:17:14 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34636 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaCQQRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:17:10 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <8761netc3z.fsf@linux.vnet.ibm.com>
References: <CAHO5Pa0Y8r1DxHTc0YN-4geoLJ3JYwHT99EcuaGL6k++ek+aEQ@mail.gmail.com>
 <8761netc3z.fsf@linux.vnet.ibm.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 17 Mar 2014 17:16:48 +0100
Message-ID: <CAKgNAkhBxCZuvyofdXwRD2TWrXEO47O_873pO8WqUBkqY1zG1w@mail.gmail.com>
Subject: Re: name_to_handle_at() and persistent filesystem IDs
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bruce Fields <bfields@fieldses.org>,
        linux-man <linux-man@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Aneesh,

On Sun, Mar 16, 2014 at 4:08 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> Michael Kerrisk <mtk.manpages@gmail.com> writes:
>
>> Hello Aneesh,
>>
>> I'm currently working on a man page for name_to_handle_at() and
>> open_by_handle_at(), and I have a question relating to a point that
>> probably needs to be covered in the man page.
>>
>> Back in July 2010, in this thread:
>> http://thread.gmane.org/gmane.linux.file-systems/41782/focus=43131
>> you said:
>>
>> [[
>> mount id should not be looked at as a persistent identifier. It should
>> be used to derive a persistent identifier from /proc/self/mountinfo. The
>> persistent identifier could be the combination of device properties,
>> file system properties or the uuid which is going to be an optional
>> tag in /proc/self/mountinfo.
>> ]]
>>
>> In the man page, I'd like to briefly describe how one derives such a
>> persistent ID from mountinfo. AFAICS, the optional UUID tag in
>> /proc/self/mountinfo has not come to pass. So, what then is the
>> recommended practice for deriving the persistent ID?
>>
>
> Anything that work for the application. mount_id will indicate which
> mount it is ie. from /proc/self/mountinfo
>
> 30 20 8:1 / /boot rw,relatime - ext4 /dev/sda1 rw,data=ordered
>
> The value 30 helps us to figure out that we are looking at device
> /dev/sda1. With that we can derive the uuid using libblkid.  I am not sure we
> concluded anything really about how to identify an nfs mount. May be we
> can do that based on server and mount point details ?.But from the
> syscall point, what we return is mount_id, which gives a hint regarding
> which mount point we are talking about in /proc/self/mountinfo. From
> that information applications can use any method that work for them
> to derivce an unique identifier.
>
> I know that NFS ganesha use these syscall. May we can check with them
> what worked for them ? (Added to CC:)

Thanks, that helped, as as I hope is evident from the page I just sent.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
