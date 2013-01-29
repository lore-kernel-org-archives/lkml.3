Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3A2UuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:50:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54389 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab3A2UuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:50:06 -0500
Message-ID: <510835C6.8070200@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 14:49:10 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv3 1/6] debugfs: add get/set for atomic types
References: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359409767-30092-2-git-send-email-sjenning@linux.vnet.ibm.com> <20130129203509.GB27740@konrad-lan.dumpdata.com>
In-Reply-To: <20130129203509.GB27740@konrad-lan.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012920-5806-0000-0000-00001EE6E128
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 02:35 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 28, 2013 at 03:49:22PM -0600, Seth Jennings wrote:
>> debugfs currently lack the ability to create attributes
>> that set/get atomic_t values.
>>
>> This patch adds support for this through a new
>> debugfs_create_atomic_t() function.
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  fs/debugfs/file.c       |   42 ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/debugfs.h |    2 ++
>>  2 files changed, 44 insertions(+)
>>
>> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
>> index c5ca6ae..fa26d5b 100644
>> --- a/fs/debugfs/file.c
>> +++ b/fs/debugfs/file.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/debugfs.h>
>>  #include <linux/io.h>
>>  #include <linux/slab.h>
>> +#include <linux/atomic.h>
>>  
>>  static ssize_t default_read_file(struct file *file, char __user *buf,
>>  				 size_t count, loff_t *ppos)
>> @@ -403,6 +404,47 @@ struct dentry *debugfs_create_size_t(const char *name, umode_t mode,
>>  }
>>  EXPORT_SYMBOL_GPL(debugfs_create_size_t);
>>  
>> +static int debugfs_atomic_t_set(void *data, u64 val)
> 
> Should the 'data' be 'atomic_t *' just to make sure nobody messes this
> up? Or would that bring too much header changes?

DEFINE_SIMPLE_ATTRIBUTE() uses simple_attr_open() whose signature
requires the argument be a void *.  So we can't change it (easily).

Seth

