Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3A2TfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:35:21 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63008 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3A2TfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:35:20 -0500
Message-ID: <51082470.2070601@suse.cz>
Date: Tue, 29 Jan 2013 20:35:12 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lingzhu Xiang <lxiang@redhat.com>, Roman Rakus <rrakus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: set_termios/set_termiox should not return -EINTR
References: <20130129190720.GA28000@redhat.com> <20130129190741.GA28004@redhat.com>
In-Reply-To: <20130129190741.GA28004@redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 08:07 PM, Oleg Nesterov wrote:
> See https://bugzilla.redhat.com/show_bug.cgi?id=904907
> read command causes bash to abort with double free or corruption (out).
> 
> A simple test-case from Roman:
> 
> 	// Compile the reproducer and send sigchld ti that process.
> 	// EINTR occurs even if SA_RESTART flag is set.
> 
> 	void handler(int sig)
> 	{
> 	}
> 
> 	main()
> 	{
> 	  struct sigaction act;
> 	  act.sa_handler = handler;
> 	  act.sa_flags = SA_RESTART;
> 	  sigaction (SIGCHLD, &act, 0);
> 	  struct termio ttp;
> 	  ioctl(0, TCGETA, &ttp);
> 	  while(1)
> 	  {
> 	    if (ioctl(0, TCSETAW, ttp) < 0)
> 	      {
> 		if (errno == EINTR)
> 		{
> 		  fprintf(stderr, "BUG!"); return(1);
> 		}
> 	      }
> 	  }
> 	}
> 
> Change set_termios/set_termiox to return -ERESTARTSYS to fix this
> particular problem.

This looks reasonable. However given the link above says:
 You are not authorized to access bug #904907.
the description above is poor. What problem exactly does this fix? Why
this should go to stable at all?

-- 
js
suse labs
