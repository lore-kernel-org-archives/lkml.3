Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaGYSiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaGYSiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:38:17 -0400
Message-ID: <53D29D0C.2040606@redhat.com>
Date: Fri, 25 Jul 2014 19:08:12 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>, Abhijith Das <adas@redhat.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Cluster-devel] [RFC] readdirplus implementations: xgetdents
 vs dirreadahead syscalls
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>	<1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com> <20140725175257.GK17798@lenny.home.zabbo.net>
In-Reply-To: <20140725175257.GK17798@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25/07/14 18:52, Zach Brown wrote:
> On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
>> Hi all,
>>
>> The topic of a readdirplus-like syscall had come up for discussion at last year's
>> LSF/MM collab summit. I wrote a couple of syscalls with their GFS2 implementations
>> to get at a directory's entries as well as stat() info on the individual inodes.
>> I'm presenting these patches and some early test results on a single-node GFS2
>> filesystem.
>>
>> 1. dirreadahead() - This patchset is very simple compared to the xgetdents() system
>> call below and scales very well for large directories in GFS2. dirreadahead() is
>> designed to be called prior to getdents+stat operations.
> Hmm.  Have you tried plumbing these read-ahead calls in under the normal
> getdents() syscalls?
>
> We don't have a filereadahead() syscall and yet we somehow manage to
> implement buffered file data read-ahead :).
>
> - z
>
Well I'm not sure thats entirely true... we have readahead() and we also 
have fadvise(FADV_WILLNEED) for that. It could be added to getdents() no 
doubt, but how would we tell getdents64() when we were going to read the 
inodes, rather than just the file names? We may only want to readahead 
some subset of the directory entries rather than all of them, so the 
thought was to allow that flexibility by making it, its own syscall,

Steve.

