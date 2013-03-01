Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab3CAJK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:10:26 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:56422 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3CAJKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:10:23 -0500
Message-ID: <51307079.2050905@suse.cz>
Date: Fri, 01 Mar 2013 10:10:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: channing <chao.bi@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ML netdev <netdev@vger.kernel.org>,
        vincentx.pillet@intel.com
Subject: Re: [PATCH] n_gsm: Add Mutex to avoid race when net destroy
References: <1362029486.31563.5.camel@bichao>  <512F28FD.9030502@suse.cz> <1362127915.31563.18.camel@bichao>
In-Reply-To: <1362127915.31563.18.camel@bichao>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 09:51 AM, channing wrote:
>> It should stop the queue and schedule a workqueue to lock the mutex,
>> unregister the hetdev and reset dlci->net. (Or maybe just call
>> muxnet_put with the lock held.)
> 
> Thanks, Jiri, you're right, I didn't notice that in validation because
> DEBUG_ATOMIC_SLEEP is not enabled in my platform :( Now I'm trying to
> work out the workqueue solution, when it finished I'll re-submit for
> review. What do you mean by "call muxnet_put with lock held"? do you
> mean to use spin lock instead of mutex?

No, I mean, in the newly added scheduled work, to lock the mutex and
simply call muxnet_put. That should fix it, right?

-- 
js
suse labs
