Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3KYSFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:05:11 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:42492 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364Ab3KYSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:05:07 -0500
Message-ID: <52939151.8030908@akamai.com>
Date: Mon, 25 Nov 2013 13:05:05 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Shawn Landden <shawnlandden@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Herbert <therbert@google.com>
Subject: Re: disappearing listen()ed SO_REUSEPORT sockets across fork() when
 using epoll
References: <CAJusiZXq0CPHNvNCKCRp=XZ8UO9gFKVsU3cTEON5BCHDxrqFZQ@mail.gmail.com>
In-Reply-To: <CAJusiZXq0CPHNvNCKCRp=XZ8UO9gFKVsU3cTEON5BCHDxrqFZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 12:53 PM, Shawn Landden wrote:
> Hello, when running the attached program on 3.12 child processes
> are missing a socket fd opened, set with SO_REUSEPORT, listen()ed to,
> and added to epoll_ctl().
> 
> This is the output I get when pointing "wget http://localhost:5555/"
> at the attached program:
> 
> main PID 31591
> PID 31634 started
> PID 31634 accept()ed connection
> PID 31635 started
> PID 31636 started
> PID 31635 accept() failed: Bad file descriptor
> PID 31636 accept() failed: Bad file descriptor
> PID 31634 accept()ed connection
> PID 31634 accept()ed connection
> PID 31634 accept()ed connection
> PID 31634 accept()ed connection
> 
> 
> While I would expect something like:
> 
> main PID 31591
> PID 31634 started
> PID 31634 accept()ed connection
> PID 31635 started
> PID 31636 started
> PID 31635 accept()ed connection
> PID 31636 accept()ed connection
> 
> -more new processes, but inversely proportional to number of listening processes
> -accept() always returns successfully
> 
> 

The 'close(sockfd);' looks to be racing with the accept() calls. Removing seems
to get the result you are looking for.

Thanks,

-Jason

