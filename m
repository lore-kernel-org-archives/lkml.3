Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaJ2KrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:47:19 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49633 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaJ2KrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:47:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heena Sirwani <heenasirwani@gmail.com>
Cc: opw-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH v8 1/2] timekeeping: Added a function to return tv_sec portion of ktime_get_ts64()
Date: Wed, 29 Oct 2014 11:47:12 +0100
Message-ID: <6923588.JzQ3nF9J4j@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <da0b63f4bdf3478909f92becb35861197da3a905.1414578445.git.heenasirwani@gmail.com>
References: <cover.1414578445.git.heenasirwani@gmail.com> <da0b63f4bdf3478909f92becb35861197da3a905.1414578445.git.heenasirwani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EX5dkEiI60CouknArrfDcaGcvdAVTYsqFtXdddFsQz0
 vbB1pG15VgMXDN9N/EScED9Cs3dwwNgowU65PX0nYtOkNmayvP
 SVRLK33zZx9NFpmevV2Yy9Qsg5TYtSsfAiu9pg1NXFjKvKN02I
 dq8fmGqht68NZdFDZxxkBmAkE5t3hfNcho3DccxkP+pv1v49nx
 6lBnOjE7vGuazVvqLEKkidGAY5KqwJVUrhTllAJfatL6STf6JJ
 aKt6LA9p9YpEOw3MSFwhttpGKkv4XAjOyJOZrCD2wC+oKkP0eD
 ghen3UxGjmhosd0q9KoE4HsUhjW1Qfs6CTEthA3RbRVLymwG4I
 E065m2ikKnTmo7hCgU5A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 16:01:16 Heena Sirwani wrote:
> The following patch adds a function to return tv_sec portion of
> ktime_get_ts64() function in order to have a function that returns
> seconds as 64-bit integers instead of 32-bit integers to address the
> y2038 problem.
> 
> Since we are interested only in the seconds portion of ktime_get_ts64()
> and require this to be as fast as possible, we take the implementation
> of ktime_get_ts64() as it is and remove everything pertaining to the
> nanoseconds portion. We only add to the seconds calculation if the
> calculation of nanoseconds is more than one billion nanoseconds. For all
> this calculation, we add a new field to the timekeeper struct,
> ktime_sec. We update this field in the function tk_update_ktime_data()
> by including the calculation of monotonic clock time in seconds and
> including the tk_xtime() implementation that gives the nanoseconds value
> of last timer click  instead of using timekeeping_get_ns() which is
> expensive and we do not require such fine resolution for nanoseconds.
> 
> Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
