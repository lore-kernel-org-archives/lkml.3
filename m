Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaLNVHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 16:07:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58860 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750986AbaLNVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 16:07:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Michal Privoznik <mprivozn@redhat.com>
Cc: trenn@suse.de, rafael.j.wysocki@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpupower: Correctly detect if running as root
Date: Sun, 14 Dec 2014 22:29:24 +0100
Message-ID: <1660884.y6rjWabQcf@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <b03faaf6b63a9175da0ce7ab8e0fc3da0cba4a86.1418560562.git.mprivozn@redhat.com>
References: <b03faaf6b63a9175da0ce7ab8e0fc3da0cba4a86.1418560562.git.mprivozn@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 14, 2014 01:36:52 PM Michal Privoznik wrote:
> Some operations, like frequency-set, need root privileges. However,
> the way that this is detected is not correct. The getuid() is called,
> while in fact geteuid() should be. This way we can allow
> distributions or users to set SETUID flags on the cpupower binary if
> they want to and let regular users change the cpu frequency governor.
> 
> Signed-off-by: Michal Privoznik <mprivozn@redhat.com>

An ACK from Thomas is needed.

> ---
>  tools/power/cpupower/utils/cpupower.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/power/cpupower/utils/cpupower.c b/tools/power/cpupower/utils/cpupower.c
> index 7cdcf88..9ea9143 100644
> --- a/tools/power/cpupower/utils/cpupower.c
> +++ b/tools/power/cpupower/utils/cpupower.c
> @@ -199,7 +199,7 @@ int main(int argc, const char *argv[])
>  	}
>  
>  	get_cpu_info(0, &cpupower_cpu_info);
> -	run_as_root = !getuid();
> +	run_as_root = !geteuid();
>  	if (run_as_root) {
>  		ret = uname(&uts);
>  		if (!ret && !strcmp(uts.machine, "x86_64") &&
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
