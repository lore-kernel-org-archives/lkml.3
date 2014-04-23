Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbaDWQrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:47:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9085 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaDWQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:47:28 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-f8-5357ee9d9a5a
From: Tomasz Figa <t.figa@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 1/3] base: power: Add generic OF-based power domain look-up
Date: Wed, 23 Apr 2014 18:46:56 +0200
Message-id: <1398271618-28932-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1398271618-28932-1-git-send-email-t.figa@samsung.com>
References: <1398271618-28932-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4Nd2578KDDaZ+MrTYOGM9q8XUh0/Y
	LOYfOcdq0f9mIatF8+L1bBbnXq1ktOhdcJXN4uvhFYwWs6bsZbLY9Pgaq8XlXXPYLD73HmG0
	mHF+H5PF7cu8Fm9+v2C3WHvkLrvF0usXmSzunjrKZjFh+loWi63zzjFanDl9idWide8Rdosf
	Z7pZLF4dbGOxWD/jNYvFql1/GC2Orw13kPZYM28No0dLcw+bx+W+XiaPnbPusnusXP6FzWPx
	npdMHptWdbJ53Lm2h81j/9w17B6bl9R7bLnazuLRt2UVo8eK1d/ZPT5vkvPYODc0gD+KyyYl
	NSezLLVI3y6BK2Pt1jdsBcsKK/61HWBtYLwf3cXIySEhYCJxYu8yFghbTOLCvfVsXYxcHEIC
	SxklPn9fCuX0MUkc+vwVrIpNQE3ic8MjNhBbREBGYuqV/awgRcwCv9glHvx9wwSSEBbwk2i8
	1gNWxCKgKrHl3E5WEJtXwEli54Zmdoh1chL/X64Aq+cUcJa40X8eLC4EVDN/8nKmCYy8CxgZ
	VjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKERN+XHYyLj1kdYhTgYFTi4VW4FR4sxJpYVlyZ
	e4hRgoNZSYR3ySKgEG9KYmVValF+fFFpTmrxIUYmDk6pBsboH50KR29FHHGwKHv9aLV1lpmm
	VkbgunBvmQkLpmaoyJrVcTFHeHr/fXF+Sfimz3ocIjqLSm4E59cy3bgnJ7POZD//su4rE1Kk
	GsPTzzho/GM6VKm/P6vp5l2jL522j7cs2HokNqiz9o2CX4zUyTzV6DZe3d888VNSRLaedO5z
	2c/+1+7jLyWW4oxEQy3mouJEAGcr6IucAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces generic code to perform power domain look-up using
device tree and automatically bind devices to their power domains.
Generic device tree binding is introduced to specify power domains of
devices in their device tree nodes.

Backwards compatibility with legacy Samsung-specific power domain
bindings is provided, but for now the new code is not compiled when
CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
will change as soon as Exynos power domain code gets converted to use
the generic framework in further patch.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Mark Brown <broonie@linaro.org>
Reviewed-by: Kevin Hilman <khilman@linaro.org>
Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
[on i.MX6 GK802]
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 .../devicetree/bindings/power/power_domain.txt     |  51 ++++
 drivers/base/power/domain.c                        | 283 +++++++++++++++++++++
 include/linux/pm_domain.h                          |  46 ++++
 kernel/power/Kconfig                               |   4 +
 4 files changed, 384 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt

diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt
new file mode 100644
index 0000000..93be5d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/power_domain.txt
@@ -0,0 +1,51 @@
+* Generic power domains
+
+System on chip designs are often divided into multiple power domains that
+can be used for power gating of selected IP blocks for power saving by
+reduced leakage current.
+
+This device tree binding can be used to bind power domain consumer devices
+with their power domains provided by power domain providers. A power domain
+provider can be represented by any node in the device tree and can provide
+one or more power domains. A consumer node can refer to the provider by
+a phandle and a set of phandle arguments (so called power domain specifier)
+of length specified by #power-domain-cells property in the power domain
+provider node.
+
+==Power domain providers==
+
+Required properties:
+ - #power-domain-cells : Number of cells in a power domain specifier;
+   Typically 0 for nodes representing a single power domain and 1 for nodes
+   providing multiple power domains (e.g. power controllers), but can be
+   any value as specified by device tree binding documentation of particular
+   provider.
+
+Example:
+
+	power: power-controller@12340000 {
+		compatible = "foo,power-controller";
+		reg = <0x12340000 0x1000>;
+		#power-domain-cells = <1>;
+	};
+
+The node above defines a power controller that is a power domain provider
+and expects one cell as its phandle argument.
+
+==Power domain consumers==
+
+Required properties:
+ - power-domain : A phandle and power domain specifier as defined by bindings
+                  of power controller specified by phandle.
+
+Example:
+
+	leaky-device@12350000 {
+		compatible = "foo,i-leak-current";
+		reg = <0x12350000 0x1000>;
+		power-domain = <&power 0>;
+	};
+
+The node above defines a typical power domain consumer device, which is located
+inside power domain with index 0 of power controller represented by node with
+label "power".
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index ae098a2..7677744 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -8,6 +8,7 @@
 
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_qos.h>
@@ -2189,3 +2190,285 @@ void pm_genpd_init(struct generic_pm_domain *genpd,
 	list_add(&genpd->gpd_list_node, &gpd_list);
 	mutex_unlock(&gpd_list_lock);
 }
+
+#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
+/*
+ * Device Tree based power domain providers.
+ *
+ * The code below implements generic device tree based power domain providers
+ * that bind device tree nodes with generic power domains registered in the
+ * system.
+ *
+ * Any driver that registers generic power domains and need to support binding
+ * of devices to these domains is supposed to register a power domain provider,
+ * which maps a power domain specifier retrieved from device tree to a power
+ * domain.
+ *
+ * Two simple mapping functions have been provided for convenience:
+ *  - of_genpd_xlate_simple() for 1:1 device tree node to domain mapping,
+ *  - of_genpd_xlate_onecell() for mapping of multiple domains per node
+ *    by index.
+ */
+
+/**
+ * struct of_genpd_provider - Power domain provider registration structure
+ * @link: Entry in global list of domain providers
+ * @node: Pointer to device tree node of domain provider
+ * @xlate: Provider-specific xlate callback mapping a set of specifier cells
+ *         into a power domain.
+ * @data: context pointer to be passed into @xlate callback
+ */
+struct of_genpd_provider {
+	struct list_head link;
+
+	struct device_node *node;
+	genpd_xlate_t xlate;
+	void *data;
+};
+
+/* List of registered power domain providers. */
+static LIST_HEAD(of_genpd_providers);
+/* Mutex to protect the list above. */
+static DEFINE_MUTEX(of_genpd_mutex);
+
+/**
+ * of_genpd_xlate_simple() - Xlate function for direct node-domain mapping
+ * @genpdspec: OF phandle args to map into a power domain
+ * @data: xlate function private data - pointer to struct generic_pm_domain
+ *
+ * This is a generic xlate function that can be used to model power domains
+ * that have their own device tree nodes. The private data of xlate function
+ * needs to be a valid pointer to struct generic_pm_domain.
+ */
+struct generic_pm_domain *of_genpd_xlate_simple(
+					struct of_phandle_args *genpdspec,
+					void *data)
+{
+	if (genpdspec->args_count != 0)
+		return ERR_PTR(-EINVAL);
+	return data;
+}
+EXPORT_SYMBOL_GPL(of_genpd_xlate_simple);
+
+/**
+ * of_genpd_xlate_onecell() - Xlate function for providers using single index.
+ * @genpdspec: OF phandle args to map into a power domain
+ * @data: xlate function private data - pointer to struct genpd_onecell_data
+ *
+ * This is a generic xlate function that can be used to model simple power
+ * domain controllers that have one device tree node and provide multiple
+ * power domains. A single cell is used as an index to an array of power
+ * domains specified in genpd_onecell_data struct when registering the
+ * provider.
+ */
+struct generic_pm_domain *of_genpd_xlate_onecell(
+					struct of_phandle_args *genpdspec,
+					void *data)
+{
+	struct genpd_onecell_data *genpd_data = data;
+	unsigned int idx = genpdspec->args[0];
+
+	if (genpdspec->args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	if (idx >= genpd_data->domain_num) {
+		pr_err("%s: invalid domain index %d\n", __func__, idx);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return genpd_data->domains[idx];
+}
+EXPORT_SYMBOL_GPL(of_genpd_xlate_onecell);
+
+/**
+ * of_genpd_add_provider() - Register a domain provider for a node
+ * @np: Device node pointer associated with domain provider.
+ * @xlate: Callback for decoding domain from phandle arguments.
+ * @data: Context pointer for @genpd_src_get callback.
+ */
+int of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
+			  void *data)
+{
+	struct of_genpd_provider *cp;
+
+	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
+	if (!cp)
+		return -ENOMEM;
+
+	cp->node = of_node_get(np);
+	cp->data = data;
+	cp->xlate = xlate;
+
+	mutex_lock(&of_genpd_mutex);
+	list_add(&cp->link, &of_genpd_providers);
+	mutex_unlock(&of_genpd_mutex);
+	pr_debug("Added domain provider from %s\n", np->full_name);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_genpd_add_provider);
+
+/**
+ * of_genpd_del_provider() - Remove a previously registered domain provider
+ * @np: Device node pointer associated with domain provider
+ */
+void of_genpd_del_provider(struct device_node *np)
+{
+	struct of_genpd_provider *cp;
+
+	mutex_lock(&of_genpd_mutex);
+	list_for_each_entry(cp, &of_genpd_providers, link) {
+		if (cp->node == np) {
+			list_del(&cp->link);
+			of_node_put(cp->node);
+			kfree(cp);
+			break;
+		}
+	}
+	mutex_unlock(&of_genpd_mutex);
+}
+EXPORT_SYMBOL_GPL(of_genpd_del_provider);
+
+/**
+ * of_genpd_get_from_provider() - Look-up power domain
+ * @genpdspec: OF phandle args to use for look-up
+ *
+ * Looks for domain provider under node specified by @genpdspec and if found
+ * uses xlate function of the provider to map phandle args to a power domain.
+ *
+ * Returns a valid pointer to struct generic_pm_domain on success or ERR_PTR()
+ * on failure.
+ */
+static struct generic_pm_domain *of_genpd_get_from_provider(
+					struct of_phandle_args *genpdspec)
+{
+	struct generic_pm_domain *genpd = ERR_PTR(-EPROBE_DEFER);
+	struct of_genpd_provider *provider;
+
+	mutex_lock(&of_genpd_mutex);
+
+	/* Check if we have such a provider in our array */
+	list_for_each_entry(provider, &of_genpd_providers, link) {
+		if (provider->node == genpdspec->np)
+			genpd = provider->xlate(genpdspec, provider->data);
+		if (!IS_ERR(genpd))
+			break;
+	}
+
+	mutex_unlock(&of_genpd_mutex);
+
+	return genpd;
+}
+
+/*
+ * Device<->domain binding using Device Tree look-up.
+ *
+ * The purpose of code below is to manage assignment of devices to their
+ * power domains in an automatic fashion, based on data read from device tree.
+ * The two functions, genpd_bind_domain() and genpd_unbind_domain() are
+ * intended to be called by higher level code that manages devices, i.e.
+ * really_probe() and __device_release_driver() to respectively bind and
+ * unbind device from its power domain.
+ *
+ * Both generic and legacy Samsung-specific DT bindings are supported to
+ * keep backwards compatibility with existing DTBs.
+ */
+
+/**
+ * genpd_bind_domain - Bind device to its power domain using Device Tree.
+ * @dev: Device to bind to its power domain.
+ *
+ * Tries to parse power domain specifier from device's OF node and if succeeds
+ * attaches the device to retrieved power domain.
+ *
+ * Returns 0 on success or negative error code otherwise.
+ */
+int genpd_bind_domain(struct device *dev)
+{
+	struct of_phandle_args pd_args;
+	struct generic_pm_domain *pd;
+	int ret;
+
+	if (!dev->of_node)
+		return 0;
+
+	ret = of_parse_phandle_with_args(dev->of_node, "power-domain",
+					"#power-domain-cells", 0, &pd_args);
+	if (ret < 0) {
+		if (ret != -ENOENT)
+			return ret;
+
+		/*
+		 * Try legacy Samsung-specific bindings
+		 * (for backwards compatibility of DT ABI)
+		 */
+		pd_args.args_count = 0;
+		pd_args.np = of_parse_phandle(dev->of_node,
+						"samsung,power-domain", 0);
+		if (!pd_args.np)
+			return 0;
+	}
+
+	pd = of_genpd_get_from_provider(&pd_args);
+	if (IS_ERR(pd)) {
+		if (PTR_ERR(pd) != -EPROBE_DEFER)
+			dev_err(dev, "failed to find power domain: %ld\n",
+				PTR_ERR(pd));
+		return PTR_ERR(pd);
+	}
+
+	dev_dbg(dev, "adding to power domain %s\n", pd->name);
+
+	while (1) {
+		ret = pm_genpd_add_device(pd, dev);
+		if (ret != -EAGAIN)
+			break;
+		cond_resched();
+	}
+
+	if (ret < 0) {
+		dev_err(dev, "failed to add to power domain %s: %d",
+			pd->name, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * genpd_unbind_domain - Unbind device from its power domain.
+ * @dev: Device to unbind from its power domain.
+ *
+ * Unbinds device from power domain previously bound to it.
+ *
+ * Returns 0 on success or negative error code otherwise.
+ */
+int genpd_unbind_domain(struct device *dev)
+{
+	struct generic_pm_domain *pd = dev_to_genpd(dev);
+	int ret;
+
+	if (!dev->of_node || IS_ERR(pd))
+		return 0;
+
+	dev_dbg(dev, "removing from power domain %s\n", pd->name);
+
+	while (1) {
+		ret = pm_genpd_remove_device(pd, dev);
+		if (ret != -EAGAIN)
+			break;
+		cond_resched();
+	}
+
+	if (ret < 0) {
+		dev_err(dev, "failed to remove from power domain %s: %d",
+			pd->name, ret);
+		return ret;
+	}
+
+	/* Check if domain can be powered off after removing this device. */
+	genpd_queue_power_off_work(pd);
+
+	return 0;
+}
+#endif
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 7c1d252..04473d4 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -310,4 +310,50 @@ static inline void pm_genpd_syscore_poweron(struct device *dev)
 	pm_genpd_syscore_switch(dev, false);
 }
 
+/* OF power domain providers */
+struct of_device_id;
+
+struct genpd_onecell_data {
+	struct generic_pm_domain **domains;
+	unsigned int domain_num;
+};
+
+typedef struct generic_pm_domain *(*genpd_xlate_t)(struct of_phandle_args *args,
+						   void *data);
+
+#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
+int of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
+			  void *data);
+void of_genpd_del_provider(struct device_node *np);
+
+struct generic_pm_domain *of_genpd_xlate_simple(
+					struct of_phandle_args *genpdspec,
+					void *data);
+struct generic_pm_domain *of_genpd_xlate_onecell(
+					struct of_phandle_args *genpdspec,
+					void *data);
+
+int genpd_bind_domain(struct device *dev);
+int genpd_unbind_domain(struct device *dev);
+#else /* !CONFIG_PM_GENERIC_DOMAINS_OF */
+static inline int of_genpd_add_provider(struct device_node *np,
+					genpd_xlate_t xlate, void *data)
+{
+	return 0;
+}
+static inline void of_genpd_del_provider(struct device_node *np) {}
+
+#define of_genpd_xlate_simple		NULL
+#define of_genpd_xlate_onecell		NULL
+
+static inline int genpd_bind_domain(struct device *dev)
+{
+	return 0;
+}
+static inline int genpd_unbind_domain(struct device *dev)
+{
+	return 0;
+}
+#endif /* CONFIG_PM_GENERIC_DOMAINS_OF */
+
 #endif /* _LINUX_PM_DOMAIN_H */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 2fac9cc..45aa98e 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -306,6 +306,10 @@ config PM_GENERIC_DOMAINS_RUNTIME
 	def_bool y
 	depends on PM_RUNTIME && PM_GENERIC_DOMAINS
 
+config PM_GENERIC_DOMAINS_OF
+	def_bool y
+	depends on PM_GENERIC_DOMAINS && OF && !ARCH_EXYNOS
+
 config CPU_PM
 	bool
 	depends on SUSPEND || CPU_IDLE
-- 
1.9.2

