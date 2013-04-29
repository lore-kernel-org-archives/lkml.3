Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3D2OB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:01:58 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:65437 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab3D2OB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:01:57 -0400
Date: Mon, 29 Apr 2013 07:01:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy Johnson <johnsonzjo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] driver: provide sysfs interfaces to access TXT log
Message-ID: <20130429140154.GA18818@kroah.com>
References: <CAF0Lin0YUfDC4dPPrjjkFK5GRfJA4=o1Q5fPRmb7o1O-jph=4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF0Lin0YUfDC4dPPrjjkFK5GRfJA4=o1Q5fPRmb7o1O-jph=4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 04:47:41PM +0300, Andy Johnson wrote:
> Hello
>   
> >Oh, and NEVER use "raw" kobjects, by doing that, you know you are >doing
> something wrong in a driver.
> 
> May I ask a short question  what do you mean by  "raw" kobjects? do you mean
> that 
> 
> struct kobject *log_kobj;
> 
> is a local variable inside a method and thus this is not 
> 
> ok?

I mean "a driver should almost never touch a 'struct kobject' directly,
or define it as a variable to be used."

Use the driver core (i.e. 'struct device' and friends), and not 'struct
kobject'.

thanks,

greg k-h
