Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaHFR1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:27:01 -0400
Received: from sf2.bxl.stone.is ([5.134.1.239]:38313 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbaHFR04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:26:56 -0400
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 13:26:56 EDT
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53E260D9.6030803@acm.org>
Date: Wed, 06 Aug 2014 19:07:37 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] spin_lock_*(): Always evaluate second argument
References: <53CE1019.10708@acm.org> <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org> <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Filter-ID: XtLePq6GTMn8G68F0EmQvdthj6rk7ohlAkaRQG+cDaLZlN3ufQ0ZRHdy43341LQ0JYRGiu4wDuX/
 sGw1Y7RAsZ3WBw9ZlycipwBG3jGu9D8JBgu10R0foqIRsBJqRnurUO/XCGxJVedBWv8BXp6lSPrf
 oA0XngOaR5RLFk6kKY8+X6tyUZ34Ozy6TOwmaHPzFR2lHDoBQ4zwtMehH4SfWgLcNhHqvET8hkHK
 4DD3CZT4SL0VvzAbTStaxE3e6xctxkHXgTSJC2+q+O2n2sPwh+CpLQk2sgUsKd5RNPNJeN3I5L/U
 AJH41ve/RciJD7RwcMm6IODZgOZ9Y8BEoKFU+QwAL7S6YYGupSBVbL2KnLMccBIk1Sag4dKiqCrF
 8eZZsQYibGPulATAPqOguWXWenmy4p4jVbvkvQrOImHI+zH4ns3e6vWEaK66hz4t87L5hVQSL57W
 w8nd1cTP1twpFFTUuHOuOBA828Pfce2frIKvtUus/ypEW5W6Dw4DmSZF9OoIMWCP9bnVs5BJWbbt
 5dM+m4WpRRDP6YzwkAPgQJZcv8AnfPB9HqHgcyCJwUz8oOSQKVK4yyKUlGmQMgPOfIQtTQXMrNAv
 J7CbCYezRVuhdlkpfoNhtgWYwB/e4S2rpoRvMJWweGFGUUnI6wOX8j4FS3UlU37B6qPMab0LB93J
 IFkIZaBCBQxuHnm838r53JPVY43DX2xu13bzR77n10CVt0DUeFU/MBWnkHtFiUWEyj6NsnagMRqM
 8j9gdkiQLAkCbSNS+uGS3B2gbpH+CQoQ5a8OxA97GyhrhjQrc+GSwIY88rqRZEl0ZFXSwVn3
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: cPaH8lomer6UwsJ3BnJDysg56Hzi1baYmi2c/60G48S0VFDyP20las9Mq1v6nXmfrqKtWpHLpkE8
 c09GKJn2t6TQwbo+S0UtFDS0IPuZMQ1MqRJTan78INzQLlEGX/jFRST5X0bRoOLYozD+qqgg13U4
 H51jyCSmLdA2hPaiVpwYWaeThsiFlmPt/lOSmjPe8esElZg6YwCZs9Idr0AN/mqK95LAXg+Ea3Jb
 F9WwpaZ//Un1C5ivAWoOksRE8XtOTT9J6CK2j8j7/AJ9TNml+IbyXSJXjZjMx+Tok7jY2RMn3BMy
 1LAXbQrwm8OFnukCzIqp+DPfGh5dERZ2moanphwkvo9vG3e4o6MWA4WRWjjE3nrK/nhevL/uAoHg
 xNXar0XzbLB8Pru9OEB7tNjak+6bpnvFzMd6SECQNf1u/wGWAJzP31LdUHDVnH0aZDcVCxO6ac9X
 hDc8gFJxmNF1qg==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.07)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/14 01:16, David Rientjes wrote:
> On Tue, 22 Jul 2014, Andrew Morton wrote:
>>> Evaluating a macro argument only if certain configuration options
>>> have been selected is confusing and error-prone. Hence always
>>> evaluate the second argument of spin_lock_nested() and
>>> spin_lock_nest_lock().
>>>
>>> An intentional side effect of this patch is that it avoids that
>>> the following warning is reported for netif_addr_lock_nested()
>>> when building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:
>>>
>>> ...
>>>
>>> --- a/include/linux/spinlock.h
>>> +++ b/include/linux/spinlock.h
>>> @@ -197,8 +197,10 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>>>  		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
>>>  	 } while (0)
>>>  #else
>>> -# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
>>> -# define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
>>> +# define raw_spin_lock_nested(lock, subclass)		\
>>> +	((void)(subclass), _raw_spin_lock(lock))
>>> +# define raw_spin_lock_nest_lock(lock, nest_lock)	\
>>> +	((void)(nest_lock), _raw_spin_lock(lock))
>>>  #endif
>>>  
>>
>> Did you try converting these to static inline functions?  That should
>> squish the warning and makes the code nicer instead of nastier...
> 
> Not sure how that would be done since _raw_spin_lock isn't declared in 
> this scope.
> 
> Taking a second look, however, I think the patch doesn't need to modify 
> raw_spin_lock_nest_lock() for the problem being reported and evaluating 
> the parameter of type struct lockdep_map * probably is meaningless.
> 
> Bart, is it possible to just get away with the raw_spin_lock_nested() 
> change?

Probably ... I will post an updated version of this patch.

Bart.
