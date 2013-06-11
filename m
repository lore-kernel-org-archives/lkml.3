Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3FKQxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:53:35 -0400
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:47619 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266Ab3FKQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:53:34 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jun 2013 12:53:34 EDT
X-AuditID: 12074422-b7f596d0000035e9-12-51b754e19f84
Message-ID: <51B754D6.6010606@mit.edu>
Date: Tue, 11 Jun 2013 09:48:22 -0700
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: vcaputo@gnugeneration.com
CC: linux-kernel@vger.kernel.org
Subject: Re: adopt(pid_t pid) syscall proposal [patch included]
References: <20130611012304.GI5638@shells.gnugeneration.com>
In-Reply-To: <20130611012304.GI5638@shells.gnugeneration.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixG6nrvswZHugwbPb7BaXd81hs2jYvoPR
	gcnj18dXzB6fN8kFMEVx2aSk5mSWpRbp2yVwZdxdvoq1YBZrxaZDf9kbGH8xdzFyckgImEjM
	/XmeBcIWk7hwbz0biC0ksI9RouUYdxcjF5C9kVHiwM/P7BDOWSaJ1Vf2MoFU8QqoSRxufA3W
	zSKgKrFzzhywbjYBFYmOpQ/AakQFwiSO/70MVS8ocXLmE7B6EQFZicN/NoBdwSygINH1bBoj
	iC0sYC9xf+JhdogrbCQOnH4HVs8pYCtx4fIboBoOoHpriW+7iyBa5SW2v53DPIFRcBaSDbMQ
	qmYhqVrAyLyKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI11QvN7NELzWldBMjOHRdlHYw/jyodIhR
	gINRiYf3gNn2QCHWxLLiytxDjJIcTEqivJP9gUJ8SfkplRmJxRnxRaU5qcWHGCU4mJVEeDcF
	AOV4UxIrq1KL8mFS0hwsSuK811Ju+gsJpCeWpGanphakFsFkZTg4lCR4lwUDNQoWpaanVqRl
	5pQgpJk4OEGG8wANjwWp4S0uSMwtzkyHyJ9iVJQS5+0BSQiAJDJK8+B6YanlFaM40CvCvPEg
	VTzAtATX/QpoMBPQ4CnqW0AGlyQipKQaGJd9eXRxE/eJAPsPK531qhZ/Wh5n7DE58Z2vtbxz
	5X3tbsP5fOmi6vYPPZYGVLrecNo/8bPfrUVzrhjwSmqVT7lqNidZ48xnvoWT+XTLU8/OmS+t
	V9+pUXHpa9gav/u8W/4eO/fHQehZ1Zz0YmZZ+ztanTMVimvVyzSjpytmu5ct/rR6xwRZJiWW
	4oxEQy3mouJEAF4hSpoIAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 06:23 PM, vcaputo@gnugeneration.com wrote:
> +			if (!uid_eq(cred->euid, tcred->suid) &&
> +			    !uid_eq(cred->euid, tcred->uid)  &&
> +			    !uid_eq(cred->uid,  tcred->suid) &&
> +			    !uid_eq(cred->uid,  tcred->uid) &&
> +			    !ns_capable(cred->user_ns, CAP_KILL)) {
> +				ret = -EPERM;
> +				goto out_unlock;
> +			}
> +

That check's far too permissive.

This sounds like it will break anything that uses wait and expects its 
children to not be stolen out from under it.

Also, you'll have problems with screen -x or the default tmux shareable 
configuration.  It sounds like this is better done in userspace.

--Andy
