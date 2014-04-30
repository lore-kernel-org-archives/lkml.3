Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaD3DXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:23:19 -0400
Received: from linuxhacker.ru ([217.76.32.60]:43805 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbaD3DXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:23:16 -0400
Subject: Re: [PATCH 11/47] staging/lustre/ptlrpc: add rpc_cache
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140429094658.GZ26890@mwanda>
Date: Tue, 29 Apr 2014 23:22:58 -0400
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Niu Yawei <yawei.niu@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <12AE96A4-126C-4CC0-A875-E9D6E61C551B@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru> <1398618431-29757-12-git-send-email-green@linuxhacker.ru> <20140429094658.GZ26890@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Apr 29, 2014, at 5:46 AM, Dan Carpenter wrote:
>> 
>> +		/* Fall through */
>> 	case 7:
>> 		sptlrpc_fini();
>> -	case 5:
>> +		/* Fall through */
>> +	case 6:
>> 		ldlm_exit();
>> -	case 4:
>> +		/* Fall through */
>> +	case 5:
>> 		ptlrpc_stop_pinger();
>> -	case 3:
>> +		/* Fall through */
>> +	case 4:
>> 		ptlrpc_connection_fini();
>> -	case 2:
>> +		/* Fall through */
>> +	case 3:
>> 		ptlrpc_exit_portals();
>> +		/* Fall through */
>> +	case 2:
>> +		ptlrpc_request_cache_fini();
>> +		/* Fall through */
>> 	case 1:
>> 		ptlrpc_hr_fini();
>> 		req_layout_fini();
>> +		/* Fall through */
>> 	default: ;
>> 	}
>> 
> 
> Heh.  Oh wow.  That's horrible.  :P
> 
> Hopefully next time someone will fix this pile of monkey poo instead
> just renumbering all the grains of corn.

Agreed.
We actually have it fixed, but it again came with some other rework that
we are probably not ready to merge anywhere yet.
I guess I can extract just this cleanup ahead of time.

Bye,
    Oleg
