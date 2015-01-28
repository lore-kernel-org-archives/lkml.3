Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbbA1DOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:14:09 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:63451 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756477AbbA1DOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 22:14:07 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56732949"
Message-ID: <54C85454.6070303@cn.fujitsu.com>
Date: Wed, 28 Jan 2015 11:15:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3.18 11/61] workqueue: fix subtle pool management issue
 which can stall whole worker_pool
References: <20150128012636.936333725@linuxfoundation.org> <20150128012638.187292688@linuxfoundation.org> <54C840BA.7020207@cn.fujitsu.com> <20150128022456.GF12314@htj.dyndns.org>
In-Reply-To: <20150128022456.GF12314@htj.dyndns.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 10:24 AM, Tejun Heo wrote:
> On Wed, Jan 28, 2015 at 09:51:54AM +0800, Lai Jiangshan wrote:
>> On 01/28/2015 09:26 AM, Greg Kroah-Hartman wrote:
>>> 3.18-stable review patch.  If anyone has any objections, please let me know.
>>
>>
>> I don't think it is a bug-fix.
>> It is just a good cleanup.
> 
> It is a bug fix, for a rare but potentially critical issue.  Please
> read the patch description.  It contains ample information on what's
> broken and also the link to the original bug report.
> 

Sorry, you are right.

Was the bug introduced at the first time when maybe_create_worker() was
introduced?  Although manage_workers()/maybe_create_worker() was changed a bit,
the stable-tree team can simply make manage_workers() return true to fix
this bug for the very old kernel versions.

