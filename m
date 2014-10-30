Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaJ3DwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 23:52:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58677 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaJ3DwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 23:52:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<1414620056-6675-4-git-send-email-gregkh@linuxfoundation.org>
Date: Wed, 29 Oct 2014 20:50:33 -0700
In-Reply-To: <1414620056-6675-4-git-send-email-gregkh@linuxfoundation.org>
	(Greg Kroah-Hartman's message of "Wed, 29 Oct 2014 15:00:47 -0700")
Message-ID: <87egtqw706.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18qhIhzWVLDKkWcVVBlu75lqBX0iXU7oJo=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4885]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 472 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.7 (0.8%), b_tie_ro: 2.6 (0.5%), parse: 1.13 (0.2%),
	extract_message_metadata: 32 (6.7%), get_uri_detail_list: 2.2 (0.5%),
	tests_pri_-1000: 11 (2.4%), tests_pri_-950: 2.3 (0.5%), tests_pri_-900: 1.94
	(0.4%), tests_pri_-400: 31 (6.6%), check_bayes: 29 (6.2%), b_tokenize: 10
	(2.2%), b_tok_get_all: 8 (1.7%), b_comp_prob: 3.8 (0.8%), b_tok_touch_all:
	2.5 (0.5%), b_finish: 0.95 (0.2%), tests_pri_0: 369 (78.0%), tests_pri_500:
	10 (2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: kdbus: add driver skeleton, ioctl entry points and utility functions
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> From: Daniel Mack <daniel@zonque.org>
>
> Add the basic driver structure.
>
> handle.c is the main ioctl command dispatcher that calls into other parts
> of the driver.
>
> main.c contains the code that creates the initial domain at startup, and
> util.c has utility functions such as item iterators that are shared with
> other files.
>
> limits.h describes limits on things like maximum data structure sizes,
> number of messages per users and suchlike. Some of the numbers currently
> picked are rough ideas of what what might be sufficient and are probably
> rather conservative.
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


> +/* kdbus control device commands */
> +static long kdbus_handle_ioctl_control(struct file *file, unsigned int cmd,
> +				       void __user *buf)
> +{
> +	case KDBUS_CMD_DOMAIN_MAKE: {
> +		const char *name;
> +
> +		if (!capable(CAP_IPC_OWNER)) {
> +			ret = -EPERM;
> +			break;
> +		}

I don't know if this is exploitable (given that this happens in an
ioctl) but capable checks outside of open usually are.

Eric


