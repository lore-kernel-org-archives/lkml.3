Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3DOH7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:59:20 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53566 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3DOH7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:59:16 -0400
Message-ID: <516BB199.1000408@linux.vnet.ibm.com>
Date: Mon, 15 Apr 2013 13:21:53 +0530
From: aruna <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 2/8] Add version and timestamp to oops header
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420> <20130410072112.20150.10281.stgit@aruna-ThinkPad-T420> <20130415073138.GB30156@concordia>
In-Reply-To: <20130415073138.GB30156@concordia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041507-3568-0000-0000-0000036E90E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 April 2013 01:01 PM, Michael Ellerman wrote:
> On Wed, Apr 10, 2013 at 12:51:12PM +0530, Aruna Balakrishnaiah wrote:
>> Introduce version and timestamp information in the oops header.
>> oops_log_info (oops header) holds version (to distinguish between old
>> and new format oops header), length of the oops text
>> (compressed or uncompressed) and timestamp.
> This needs a much more detailed explanation.
>
> I think what you're doing is you're overlaying the new information so
> that the version field in oops_log_info sits in the same location as the
> length field in the old format. And then you're defining the version to
> be a value that is an illegal length.

Thats right.

> So existing tools will refuse to dump new style partitions,
> because they'll think the length is too large. You've tested that?

Yeah, I have tested that.

>
> Updated tools will know about both formats, so will be able to handle
> either old or new style partitions.
>
> Is that correct?

Yeah, thats correct.

>
> And we're adding the timestamp just because we can and it'd be nice to
> have?

Thats right. And also, the main reason behind adding timestamp is
it will be used when we create a pstore file for oops messages.
The pstore file's timestamp will reflect the timestamp in the oops-header
added during the crash.

> cheers
>

