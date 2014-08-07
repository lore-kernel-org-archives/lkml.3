Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaHGCAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 22:00:37 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54061 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaHGCAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 22:00:35 -0400
X-Original-SENDERIP: 10.177.31.16
X-Original-MAILFROM: hyogi.gim@lge.com
Message-ID: <53E2DDBC.1060603@lge.com>
Date: Thu, 07 Aug 2014 11:00:28 +0900
From: Hyogi Gim <hyogi.gim@lge.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] alarmtimer: Add the verification code for rtc device
 error.
References: <1405041854-17902-1-git-send-email-hyogi.gim@lge.com> <CALAqxLWcX9DV=1W7D9GNLz2UHvy7neFywuzpc32UfXTnNfvMmg@mail.gmail.com>
In-Reply-To: <CALAqxLWcX9DV=1W7D9GNLz2UHvy7neFywuzpc32UfXTnNfvMmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/31/2014 02:58 AM, John Stultz wrote:
> 
> Hey! Sorry for the late response here.
> 
> So this seems reasonable as always failing suspend is problematic, but
> I worry that for the case where we do have a failure to read or set
> the RTC, we'd suspend and not wake up as specified, which is an issue
> as well. Absorbing the error silently in these cases would make it
> difficult to debug. Should we at least print some output out to help
> folks hunt down this sort of issue?
> 

I agree. Most RTC device drivers don't print out the error of read_time.        
So, I think the higher level like /drivers/rtc/interface.c should check          
the error and give the information of the RTC device status.                    
                                                                                
I'll try to find a proper point.
