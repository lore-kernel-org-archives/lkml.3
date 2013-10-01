Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3JAWe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:34:58 -0400
Received: from mout.gmx.net ([212.227.15.15]:56643 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab3JAWe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:34:56 -0400
Message-ID: <524B4E0D.9050107@gmx.de>
Date: Wed, 02 Oct 2013 00:34:53 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Libin <huawei.libin@huawei.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in print_worker_info()
 before use
References: <20131001203520.GA8248@p100.box> <20131001204352.GA27149@mtj.dyndns.org> <524B364B.3010405@gmx.de> <20131001210348.GB27149@mtj.dyndns.org> <20131001210735.GA27867@mtj.dyndns.org>
In-Reply-To: <20131001210735.GA27867@mtj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:os7WkJVtTLLP5PuRYoMf5EZRdO47meSRH8Zalr0C19i5m8DdIvu
 u/sxa0a0No9+B4KxLWeH5K+/NURHyzn/1bRxONUo7xOtYt6tp/5t4KXZ4KO0Gg+5+17fuus
 jC74u9wb0LwKpvZajuAcJpbCgRaUla9wJkBiaWjGz+K6rsaRnWQ7EiHXp4eILowN1I3VRw2
 klgkYr6Fh6x/Zq3pD6jZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 11:07 PM, Tejun Heo wrote:
> On Tue, Oct 01, 2013 at 05:03:48PM -0400, Tejun Heo wrote:
>> On Tue, Oct 01, 2013 at 10:53:31PM +0200, Helge Deller wrote:
>>> So, in summary my patch here is not really necessary, but for the sake of
>>> clean code I think it doesn't hurt either and as such it would be nice if
>>> you could apply it.
>>
>> What? function *must* take any value and try to access it and not
>> cause failure.  That's the *whole* purpose of that interface.  How is
>> having incomplete spurious checks around it "clean code" in any sense
>> of the word?  That doesn't make any sense.
> 
> Just in case you didn't know already.  probe_kernel_read()'s role is
> to take any ulong value and dereference it if it can.  If not, it can
> return any value, but it shouldn't crash in any case.  If you're just
> adding NULL test in probe_kernel_read(), you're just masking a common
> failure pattern and the kernel still *will* panic while dumping the
> states.  If a specific arch doesn't have proper probe_kernel_read()
> implementation, adding if (!NULL) test there could be a temporary
> workaround, but it should be clearly marked as such.

Sure, probe_kernel_read() takes care that no segfaults will happen.
Nevertheless, if we know that "pwq" might become NULL, why access pwq->wq at all?
  struct pool_workqueue *pwq = NULL;
  probe_kernel_read(&wq, &pwq>wq, sizeof(wq));

If you wouldn't have used probe_kernel_read() you would never code it 
like that. That's what I meant when I wrote "clean coding" (aka "similar
to what you would have done without probe_kernel_read()").

Helge
