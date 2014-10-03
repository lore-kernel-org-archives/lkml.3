Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaJCRkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 13:40:19 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:59013 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbaJCRkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 13:40:15 -0400
Message-ID: <1412357993.20838.4.camel@linux-t7sj.site>
Subject: Re: [PATCH v3 3/5] selftests/ipc: change test to use ksft framework
From: Davidlohr Bueso <dave@stgolabs.net>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 10:39:53 -0700
In-Reply-To: <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
	 <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 09:36 -0600, Shuah Khan wrote:
>  	msgque.key = ftok(argv[0], 822155650);
>  	if (msgque.key == -1) {
> -		printf("Can't make key\n");
> -		return -errno;
> +		printf("Can't make key: %d\n", -errno);

So printing a numeric value is quite useless when users actually run
into these errors -- which is why I like err() so much. How about using
strerror() instead?

Thanks,
Davidlohr

